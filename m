Return-Path: <SRS0=xGmm=LA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbeHQSQb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Aug 2018 14:16:31 -0400
Date: Fri, 17 Aug 2018 11:12:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kernel-shark-qt: Add I/O for configuration data.
Message-ID: <20180817111245.64a2ffcc@gandalf.local.home>
In-Reply-To: <f364f502-c14f-b5ee-c4d7-1dc7634ade6d@gmail.com>
References: <20180816150729.4680-1-y.karadz@gmail.com>
        <20180816150729.4680-2-y.karadz@gmail.com>
        <20180816145219.7e91e435@gandalf.local.home>
        <0a535d0f-333c-f002-970c-33c5a8937b05@gmail.com>
        <20180817084958.11361418@gandalf.local.home>
        <38b58799-95e7-53c0-8398-2b590dfb1192@gmail.com>
        <20180817105842.7f14e6e7@gandalf.local.home>
        <f364f502-c14f-b5ee-c4d7-1dc7634ade6d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 17 Aug 2018 18:09:44 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 17.08.2018 17:58, Steven Rostedt wrote:
> > And we can have more than one file saved in the session. Hmm, I wonder
> > if we should add code to see if files still exist, and remove the
> > information if they do not.  
> 
> Actually if you use this a lot you may have a big number of *.json files 
> in your work directory. And some of these files can represent sessions, 
> some other only filters. But when you click on the Session Import, for 
> example, the Open File dialog will show you all *.json files. In this 
> case you may get confused and try to open a wrong file. This is the 
> reason why we need the "type" field.
> 

I was actually thinking of having a single json file that stores all
"full sessions". Like a .viminfo file. The specific filters and such
should probably be in separate files as that would be how people could
load and save them.

-- Steve
