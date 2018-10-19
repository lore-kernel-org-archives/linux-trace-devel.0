Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f45.google.com ([209.85.128.45]:37888 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbeJTAoK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 20:44:10 -0400
Received: by mail-wm1-f45.google.com with SMTP id 193-v6so4266536wme.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Oct 2018 09:37:18 -0700 (PDT)
Subject: Re: Issue with making of doxygen files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20181019114029.6ec42a95@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <002df723-e710-ade0-3156-eac106aaf4f5@gmail.com>
Date: Fri, 19 Oct 2018 19:37:15 +0300
MIME-Version: 1.0
In-Reply-To: <20181019114029.6ec42a95@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 19.10.2018 18:40, Steven Rostedt wrote:
> Hi Yordan,
> 
> It appears we may be missing a dependency, as I tried to build the
> doxygen files on my workstation and got this:
> 
> [rostedt@vypre build]$ make
> Scanning dependencies of target doc
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> [...]
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> sh: epstopdf: command not found
> error: Problems running epstopdf. Check your TeX installation!
> [  0%] Built target doc
> [ 10%] Built target kshark
> [ 15%] Built target kshark-plot
> [ 68%] Built target kshark-gui
> [ 71%] Built target kernelshark
> [ 75%] Built target kshark-record
> [ 80%] Built target sched_events
> [ 83%] Built target dhisto
> [ 86%] Built target confio
> [ 90%] Built target dfilter
> [ 93%] Built target dplot
> [ 96%] Built target dload
> [100%] Built target widgetdemo
> 
> 
> Seems I'm missing the utility epstopdf.

This is a LaTeX package. I guess it is needed to generate pdf documentation.

Please try adding to "kernel-shark-qt/doc/dox_config" a line

GENERATE_LATEX  = NO

and see if the problem still persist. I don't want to add LaTeX as 
dependency.

Thanks!
Yordan


> 
> -- Steve
> 
