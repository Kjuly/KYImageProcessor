//
//  KYImageProcessingLogger.swift
//  KYImageProcessing
//
//  Created by Kjuly on 22/12/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if DEBUG
func KYImageProcessingLog(
  _ message: String,
  function: String = #function,
  file: String = #file,
  line: Int = #line
) {
  let fileString: NSString = NSString(string: file)
  print("🟣 DEBUG -[\(fileString.lastPathComponent) \(function)] L\(line): \(message)")
}
#else
func KYImageProcessingLog(_ message: String) {}
#endif
