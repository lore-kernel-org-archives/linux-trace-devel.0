Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbeJTArj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 20:47:39 -0400
Date: Fri, 19 Oct 2018 12:40:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Issue with making of doxygen files
Message-ID: <20181019124045.2ad35fa4@gandalf.local.home>
In-Reply-To: <002df723-e710-ade0-3156-eac106aaf4f5@gmail.com>
References: <20181019114029.6ec42a95@gandalf.local.home>
        <002df723-e710-ade0-3156-eac106aaf4f5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 19 Oct 2018 19:37:15 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> > Seems I'm missing the utility epstopdf.  
> 
> This is a LaTeX package. I guess it is needed to generate pdf documentation.
> 
> Please try adding to "kernel-shark-qt/doc/dox_config" a line
> 
> GENERATE_LATEX  = NO
> 
> and see if the problem still persist. I don't want to add LaTeX as 
> dependency.
> 

I can confirm that adding it removes the warnings and removing it
brings them back.

Can you make that generated? That is, have cmake check if the latex
packages are installed, and if they are you create them?

-- Steve
