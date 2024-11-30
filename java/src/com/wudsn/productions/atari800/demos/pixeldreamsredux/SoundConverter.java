package com.wudsn.productions.atari800.demos.pixeldreamsredux;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public final class SoundConverter {

	int BLOCK_SIZE = 0x4000;

	public static void main(String[] args) {
		SoundConverter soundConverter = new SoundConverter();
		int result=soundConverter.run(args);
		System.exit(result);
	}

	SoundConverter() {
	}

	public int run(String[] args) {
		if (args.length != 3) {
			System.err.println("ERROR: Invalid arguments. Use: <rawFile> <covoxFile> <pokeyFile>");
			return 1;
		}
		File inputFile = new File(args[0]);
		File covoxFile = new File(args[1]);
		File pokeyFile = new File(args[2]);
		int length = (int) inputFile.length();
		int fixedLength = (length / BLOCK_SIZE) * BLOCK_SIZE;

		System.out.println("Converting 0x" + Long.toHexString(fixedLength) + " of 0x" + Long.toHexString(length)
				+ " bytes in \"" + inputFile.getName() + "\" to \"" + covoxFile.getName() + "\" and \"" + pokeyFile.getName()
				+ "\".");

		byte[] inputData = new byte[fixedLength];
		byte[] covoxData = new byte[fixedLength];
		byte[] pokeyData = new byte[fixedLength];

		InputStream inputStream = null;
		OutputStream covoxStream = null;
		OutputStream pokeyStream = null;
		try {

			inputStream = new FileInputStream(inputFile);
			covoxStream = new FileOutputStream(covoxFile);
			pokeyStream = new FileOutputStream(pokeyFile);
			if (inputStream.read(inputData, 0, fixedLength) != fixedLength) {
				throw new IOException("Length does not match");
			}
			convert(fixedLength, inputData, covoxData, pokeyData);
			covoxStream.write(covoxData);
			pokeyStream.write(pokeyData);

		} catch (IOException e) {
			System.err.println("ERROR: I/O exception occurred.");
			e.printStackTrace(System.err);
			return 1;
		} finally {
			if (covoxStream != null) {
				try {
					covoxStream.close();
				} catch (IOException e) {
					// Ignore
				}
			}
			if (pokeyStream != null) {
				try {
					pokeyStream.close();
				} catch (IOException e) {
					// Ignore
				}
			}
			if (inputStream != null) {
				try {

					inputStream.close();
				} catch (IOException e) {
					// Ignore
				}
			}
		}
		System.out.println("Done.");
		return 0;
	}

	private void convert(int length, byte[] inputData, byte[] covoxData, byte[] pokeyData) {
		int min = Integer.MAX_VALUE;
		int max = Integer.MIN_VALUE;
		int offset = 1;
		for (int i = 0; i < length; i++) {
			int b = (inputData[i] +offset)& 0xff;
			if (b < min) {
				min = b;
			}
			if (b > max) {
				max = b;
			}
		}
		System.out.println("Input data min=" + min + ", max=" + max + ".");

		for (int i = 0; i < length; i++) {
			int b = (inputData[i] +offset)& 0xff;

			int c = b;
			covoxData[i] = (byte) c;

			int p = ((b >>> 4) | 0x10);
			pokeyData[i] = (byte) p;
		}
	}

}
