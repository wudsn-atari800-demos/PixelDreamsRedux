package com.wudsn.productions.atari800.demos.pixeldreamsredux;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Comparator;

public final class FileSequenceFilter {

	private static class FileComparator implements Comparator<File> {

		@Override
		public int compare(File o1, File o2) {
			return o1.getAbsolutePath().compareTo(o2.getAbsolutePath());

		}

	}

	public static void main(String[] args) {
		FileSequenceFilter instance = new FileSequenceFilter();
		System.exit(instance.run(args));
	}

	private FileSequenceFilter() {
	}

	private static byte[] readFileContent(File file) throws IOException {
		long fileSize = file.length();
		byte[] content = new byte[(int) fileSize];
		InputStream inputStream = null;

		try {
			inputStream = new FileInputStream(file);

			int bytesRead = inputStream.read(content);
			if (bytesRead != fileSize) {
				throw new IOException("File is too short");
			}
		} finally {
			if (inputStream != null) {
				inputStream.close();
			}
		}
		return content;

	}

	private static void writeFileContent(File file, byte[] content) throws IOException {
		FileOutputStream outputStream = null;

		try {
			outputStream = new FileOutputStream(file);
			outputStream.write(content);

		} finally {
			if (outputStream != null) {
				outputStream.close();
			}
		}
	}

	private static void log(String text, String... args) {
		if (args != null) {
			for (int i = 0; i < args.length; i++) {
				text = text.replace("{" + i + "}", args[i]);
			}
		}
		System.out.println(text);

	}

	public int run(String[] args) {

		if (args.length < 2) {
			log("Usage: FileSequenceFilter <sourceFolder> <targetFolder> [<firstFileName]");
			log("Working directory is {0}", new File("").getAbsolutePath());

			return -1;
		}
		String sourceFolderPath = args[0];
		String targetFolderPath = args[1];

		File sourceFolder = new File(sourceFolderPath);
		if (!sourceFolder.exists()) {
			log("ERROR: Source folder {0} does not exist.", sourceFolderPath);
			return -1;

		}
		File targetFolder = new File(targetFolderPath);
		if (targetFolder.exists()) {
			if (targetFolder.getAbsoluteFile().equals(sourceFolder.getAbsoluteFile())) {
				log("ERROR: Source folder {0} must not be used as target folder.", sourceFolderPath);
				return -1;
			}
			if (targetFolder.isDirectory()) {
				File[] files = targetFolder.listFiles();
				for (File file : files) {
					if (!file.delete()) {
						log("ERROR: Cannot delete {0}.", file.getAbsolutePath());
						return -1;
					}
				}
			} else {
				log("ERROR: Path {0} is no directory.", targetFolderPath);
				return -1;
			}

		} else {
			if (!targetFolder.mkdirs()) {
				log("ERROR: Target folder {0} cannot be created.", targetFolderPath);
				return -1;
			}

		}



	String firstFileName = null;
	if (args.length == 3) {
		firstFileName = args[2];
	}
	
	File[] files = sourceFolder.listFiles();if(files!=null)
	{
		Arrays.sort(files, new FileComparator());
		File lastFile = null;
		byte[] lastFileContent = null;
		log("Processing {0} files in {1}", Long.toString(files.length), sourceFolderPath);
		int fileCount = 0;
		for (File file : files) {
			if (firstFileName!=null && !file.getName().equals(firstFileName)){
				continue;
			}
			firstFileName=null;
			try {
				byte[] fileContent = readFileContent(file);
				if (lastFile == null || !Arrays.equals(fileContent, lastFileContent)) {
					File outputFile = new File(targetFolder, file.getName());
					fileCount++;
					log("INFO: Copying file number {0} - {1}", String.valueOf(fileCount), file.getName());

					writeFileContent(outputFile, fileContent);
				}
				lastFile = file;
				lastFileContent = fileContent;
			} catch (IOException ex) {
				log("ERROR: Error when processing {0}: {1}", file.getAbsolutePath(), ex.getMessage());
				return -1;
			}

		}
	}

	log("Done.");

		return 0;
	}
}