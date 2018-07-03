Return-Path: <SRS0=hWWP=JT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932312AbeGCQYd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jul 2018 12:24:33 -0400
Message-Id: <20180703162130.082810105@goodmis.org>
Date: Tue, 03 Jul 2018 12:21:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/3] kernel-shark-qt: Merge kshark_load_data_records/entries()
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


This works to consolidate the functions kshark_load_data_records()
with kshark_load_data_entries(). It adds some helper functions
for the two to use to simplify the code.

Note, doxygen warns that struct rec_list is not documented. Really?
Such a simple structure doesn't really require documentation. Is
there a way to shut it up? Or I can just add code to say
 /** Shut doxygen up! ;-)

Yordan, please review these.

Steven Rostedt (VMware) (3):
      kernel-shark-qt: Move declarations to top in datafilter.c example
      kernel-shark-qt: Consolidate load_data_entries and load_data_records
      kernel-shark-qt: Add helper function to find the next_cpu in kshark_load_data_*()

----
 kernel-shark-qt/examples/datafilter.c |   5 +-
 kernel-shark-qt/src/libkshark.c       | 253 ++++++++++++++++++++--------------
 2 files changed, 151 insertions(+), 107 deletions(-)
