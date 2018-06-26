Return-Path: <SRS0=k4No=JM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbeFZPQO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jun 2018 11:16:14 -0400
Date: Tue, 26 Jun 2018 11:16:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/7] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180626111611.67bae931@gandalf.local.home>
In-Reply-To: <aaaaab86-51c0-506e-939e-1604274e09fc@gmail.com>
References: <20180625150121.14291-1-y.karadz@gmail.com>
        <20180625150121.14291-4-y.karadz@gmail.com>
        <20180625143006.6b2cbad3@gandalf.local.home>
        <aaaaab86-51c0-506e-939e-1604274e09fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 26 Jun 2018 17:47:13 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > How hard would it be to switch over?  
> 
> I have no experience with "kernel doc", so I have no idea if it will be 
> easy or hard. I can try to investigate, but this will take some time.
> I this the way to go?

Doing a search, I found this link:

https://groups.google.com/forum/#!topic/jailhouse-dev/mkfNiU3epaY

It's from Jan Kiszka (you may have met him in Prague. He gave one of
the keynotes, and is the author of Jailhouse). Seems he finds
kernel-doc limiting, and prefers doxygen. I respect Jan's opinion in
this (oh, and he was on the Alps with me too). Let's follow the
jailhouse use of doxygen. Would that do?

-- Steve
