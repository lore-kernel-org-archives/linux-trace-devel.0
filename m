Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37004 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbeAPPEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 10:04:54 -0500
Message-ID: <1516115090.12026.24.camel@gmail.com>
Subject: Re: [PATCH v2 2/3] trace-cmd: Remove the die() call from read_proc()
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jan 2018 17:04:50 +0200
In-Reply-To: <20180112104355.01ea2c86@gandalf.local.home>
References: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
         <20171221152520.25867-3-vladislav.valtchev@gmail.com>
         <20180112104355.01ea2c86@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 2018-01-12 at 10:43 -0500, Steven Rostedt wrote:
> 
> But you need to handle the error cases for the users of read_proc().
> From the previous patch:
> 
>  static void change_stack_tracer_status(int new_status)
>  {
> 	char buf[1];
> 	int status;
> 	int fd;
> 	int n;
>  
> 	if (read_proc(&status) > 0 && status == new_status)
> 		return; /* nothing to do */
> 
> We should not continue if read_proc() fails. Should move the die here:
> 
> 	ret = read_proc(&status);
> 	if (ret < 0)
> 		die("error reading %s", PROC_FILE);
> 
> 	if (ret > 0 && status == new_status)
> 		return; /* nothing to do */
> 
> -- Steve
> 

You're totally right. I overlooked at this detail.

-- 
Vladislav Valtchev
VMware Open Source Technology Center
