package com.wudsn.productions.atari800.demos.pixeldreamsredux;

import java.awt.FlowLayout;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EmptyBorder;

public final class GraphicsConverter {

	static final int RGB_MASK = 0xffffff;

	static final class ColorCount {

		public ColorCount() {

		}

		public int color;
		public long count;
	}

	static final class ColorCountComparator implements Comparator<ColorCount> {

		@Override
		public int compare(ColorCount o1, ColorCount o2) {
			if (o1.count == o2.count) {
				return 0;
			}
			if (o1.count < o2.count) {
				return +1;
			}
			return -1;
		}

	}

	static final class Histogram {

		private long pixelCount;
		private java.util.List<ColorCount> colorCounts;

		public Histogram(BufferedImage image) {
			colorCounts = new ArrayList<ColorCount>();
			pixelCount = 0;
			Map<Integer, ColorCount> map = new TreeMap<Integer, ColorCount>();
			for (int y = 0; y < image.getHeight(); y++) {
				for (int x = 0; x < image.getWidth(); x++) {
					int color = image.getRGB(x, y) & RGB_MASK;
					Integer key = Integer.valueOf(color);
					ColorCount colorCount = map.get(key);
					if (colorCount == null) {
						colorCount = new ColorCount();
						colorCount.color = color;
						colorCount.count = 1;
						map.put(key, colorCount);
					} else {
						colorCount.count++;
					}
					pixelCount++;
				}
			}
			colorCounts.addAll(0, map.values());
			colorCounts.sort(new ColorCountComparator());
			colorCounts = Collections.unmodifiableList(colorCounts);

		}

		public long getPixelCount() {
			return pixelCount;
		}

		long getDistinactColorCount() {
			return colorCounts.size();
		}

		public java.util.List<ColorCount> getColorCounts() {
			return colorCounts;
		}

		public ColorCount getColorCount(int index) {
			return colorCounts.get(index);
		}

		public int getColorCountIndex(int color) {
			for (int i = 0; i < colorCounts.size(); i++) {
				if (colorCounts.get(i).color == color) {
					return i;
				}
			}
			return -1;
		}

		@Override
		public String toString() {
			StringBuffer buffer = new StringBuffer();
			long distinctColorCount = getDistinactColorCount();
			System.out.print(pixelCount + " pixels with " + distinctColorCount + " distinct colors: ");
			for (int i = 0; i < distinctColorCount; i++) {
				ColorCount colorCount = colorCounts.get(i);
				buffer.append(Integer.toHexString(colorCount.color) + "=" + colorCount.count + " ("
						+ (colorCount.count * 100 / pixelCount) + "%)");
				if (i < distinctColorCount - 1) {
					buffer.append(", ");
				}
			}
			return buffer.toString();
		}

	}

	private static final class Stage {
		public BufferedImage image;
		public ImageIcon imageIcon;
		public JLabel imageLabel;

		public Stage() {
			imageIcon = new ImageIcon();
			imageLabel = new JLabel();
			imageLabel.setIcon(imageIcon);
		}

		void setImage(BufferedImage image) {
			if (image == null) {
				throw new IllegalArgumentException("Parameter image must not be null.");
			}
			this.image = image;
			imageIcon.setImage(image);
			imageLabel.setBorder(new EmptyBorder(8, 8, 8, 8));
			imageLabel.setSize(image.getWidth(null), image.getHeight(null));
		}
	}

	public static void main(String[] args) {
		GraphicsConverter graphicsConverter = new GraphicsConverter();
		int result = graphicsConverter.run(args);
		if (result != 0) {
			System.exit(result);
		}
	}

	private List<Stage> stageList;
	private JFrame frame;

	GraphicsConverter() {
		stageList = new ArrayList<Stage>();
	}

	private void addStage(BufferedImage image) {
		Stage stage = new Stage();
		stage.setImage(image);
		stageList.add(stage);
	}

	public int run(String[] args) {

		if (args.length!=1) {
				System.err.println("ERROR: Invalid arguments. Use: <sourceFolder>");
				return 1;
		}
		String sourceFolderPath = args[0];
		File sourceFolder = new File(sourceFolderPath);
		for (File sourceFile : sourceFolder.listFiles()) {
			convertFile(sourceFile);
		}

//	JButton button = new JButton("Next frame");
//	button.addActionListener(new ActionListener() {
//	    @Override
//	    public void actionPerformed(ActionEvent e) {
//		step();
//		paint();
//	    }
//	});

		frame = new JFrame("GraphicsConverter");
		JPanel container = new JPanel();
		JScrollPane scrPane = new JScrollPane(container);
		frame.add(scrPane);
		container.setLayout(new FlowLayout());
		for (Stage stage : stageList) {
			container.add(stage.imageLabel);
		}

//	frame.getContentPane().add(BorderLayout.SOUTH, button);
		frame.pack();
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);
		
		return 0;

	}

	private void convertFile(File sourceFile) {

		BufferedImage image;
		try {
			image = ImageIO.read(sourceFile);
			printInfo(image);

		} catch (IOException ex) {
			throw new RuntimeException("Error reading image from " + sourceFile.getAbsolutePath() + "'", ex);
		}

		image = scale(image, 0.5d);
		printInfo(image);

		addStage(image);

		image = extract(image, 48, 29, 320, 200 - 20);
		printInfo(image);

		addStage(image);

		Histogram histogram = new Histogram(image);

		BufferedImage image3 = createReduced(image, 0);
		addStage(image3);
		System.out.print(histogram.toString());

		BufferedImage image4 = createReduced(image, 1);
		addStage(image4);
	}

	BufferedImage createEmpty(BufferedImage image) {
		return new BufferedImage(image.getWidth(), image.getHeight(), image.getType());
	}

	BufferedImage scale(BufferedImage image, double factor) {
		AffineTransform at = new AffineTransform();
		at.setToScale(factor, factor);
		AffineTransformOp atop = new AffineTransformOp(at, null);
		return atop.filter(image, null);
	}

	BufferedImage extract(BufferedImage image, int x, int y, int width, int height) {
		BufferedImage result = new BufferedImage(width, height, image.getType());
		for (int j = 0; j < height; j++) {
			for (int i = 0; i < width; i++) {

				result.setRGB(i, j, image.getRGB(x + i, y + j));
			}
		}
		return result;
	}

	BufferedImage createReduced(BufferedImage image, int frame) {
		BufferedImage result = createEmpty(image);
		for (int y = 0; y < image.getHeight(); y++) {
			int start = y;
			if (start > 0) {
				start = start - 1;
			}
			int end = y;
			if (end < image.getHeight() - 1) {
				end = end + 1;
			}
			BufferedImage lineImage = extract(image, 0, start, image.getWidth(), end - start + 1);
			Histogram histogram = new Histogram(lineImage);

//			System.out.println("Line " + y + ": " + histogram.toString());
			int maxColorsPerLine = 4;
			for (int x = 0; x < image.getWidth(); x = x + 2) {
				int xoffset = (y + frame) & 1;
				int color = image.getRGB(x + xoffset, y) & RGB_MASK;
				int index = histogram.getColorCountIndex(color);
				if (index < 0) {

					throw new RuntimeException("Invalid color " + color);
				} else if (index > maxColorsPerLine) {
					color = histogram.getColorCount(maxColorsPerLine - 1).color;
				}
				result.setRGB(x, y, color);
				result.setRGB(x + 1, y, color);

			}
		}
		Histogram histogram = new Histogram(result);
		printInfo(result);
		System.out.print(histogram.toString());

		return result;
	}

	private void printInfo(BufferedImage image) {
		System.out.println("Width=" + image.getWidth() + " Height=" + image.getHeight());
	}

}