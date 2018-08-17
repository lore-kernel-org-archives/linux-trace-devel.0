Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbeHQSin (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 14:38:43 -0400
Date: Fri, 17 Aug 2018 11:34:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
Message-ID: <20180817113451.52db13d1@gandalf.local.home>
In-Reply-To: <7949286d-dd20-3ec7-4d8f-4e8356432f84@gmail.com>
References: <20180816150729.4680-1-y.karadz@gmail.com>
        <20180816150729.4680-2-y.karadz@gmail.com>
        <20180816145219.7e91e435@gandalf.local.home>
        <0a535d0f-333c-f002-970c-33c5a8937b05@gmail.com>
        <20180817084958.11361418@gandalf.local.home>
        <38b58799-95e7-53c0-8398-2b590dfb1192@gmail.com>
        <20180817105842.7f14e6e7@gandalf.local.home>
        <f364f502-c14f-b5ee-c4d7-1dc7634ade6d@gmail.com>
        <20180817111245.64a2ffcc@gandalf.local.home>
        <7949286d-dd20-3ec7-4d8f-4e8356432f84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 17 Aug 2018 18:29:49 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > I was actually thinking of having a single json file that stores all
> > "full sessions". Like a .viminfo file.  
> 
> This is a good idea.
> 
> But we have to support saving individual sessions as well. Mainly for 

Makes sense.

-- Steve

> bug reports. In my work directory I have a lot of files called 
> bugXX.json ;-)
> 
> Actually we can add a menu for creating a tarball containing trace.dat 
> and session.json.
>
