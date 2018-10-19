Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbeJSXrJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 19:47:09 -0400
Date: Fri, 19 Oct 2018 11:40:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Issue with making of doxygen files
Message-ID: <20181019114029.6ec42a95@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Yordan,

It appears we may be missing a dependency, as I tried to build the
doxygen files on my workstation and got this:

[rostedt@vypre build]$ make
Scanning dependencies of target doc
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
[...]
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
sh: epstopdf: command not found
error: Problems running epstopdf. Check your TeX installation!
[  0%] Built target doc
[ 10%] Built target kshark
[ 15%] Built target kshark-plot
[ 68%] Built target kshark-gui
[ 71%] Built target kernelshark
[ 75%] Built target kshark-record
[ 80%] Built target sched_events
[ 83%] Built target dhisto
[ 86%] Built target confio
[ 90%] Built target dfilter
[ 93%] Built target dplot
[ 96%] Built target dload
[100%] Built target widgetdemo


Seems I'm missing the utility epstopdf.

-- Steve
