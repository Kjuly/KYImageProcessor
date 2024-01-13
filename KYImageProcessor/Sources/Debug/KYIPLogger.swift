//
//  KYIPLogger.swift
//  KYImageProcessor
//
//  Created by Kjuly on 22/12/2023.
//  Copyright © 2023 Kaijie Yu. All rights reserved.
//

import Foundation

#if DEBUG
func KYIPLog(
  _ message: String,
  function: String = #function,
  file: String = #file,
  line: Int = #line
) {
  let fileString: NSString = NSString(string: file)
  print("🟣 DEBUG -[\(fileString.lastPathComponent) \(function)] L\(line): \(message)")
}
#else
func KYIPLog(_ message: String) {}
#endif
