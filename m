Return-Path: <SRS0=Tl+h=JW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:55308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934021AbeGFSYm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jul 2018 14:24:42 -0400
Date: Fri, 6 Jul 2018 14:24:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180706142440.4d913909@gandalf.local.home>
In-Reply-To: <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
        <20180705180544.7210caad@gandalf.local.home>
        <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 6 Jul 2018 15:46:54 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > --- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.h
> > +++ trace-cmd.git/kernel-shark-qt/src/libkshark.h
> > @@ -33,6 +33,9 @@ extern "C" {
> >    * info etc.) is available on-demand via the offset into the trace file.
> >    */
> >   struct kshark_entry {
> > +	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
> > +	struct kshark_entry *next; /* MUST BE FIRST ENTRY */
> > +  
> Correct, thanks!

BTW, I was going to ask. Do you use entry->next elsewhere (to get per
cpu lists)?

-- Steve
