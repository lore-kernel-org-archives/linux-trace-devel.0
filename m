Return-Path: <SRS0=Tl+h=JW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934112AbeGFSnh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Jul 2018 14:43:37 -0400
Date: Fri, 6 Jul 2018 14:43:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180706144334.330ebf1d@gandalf.local.home>
In-Reply-To: <20180706142104.42fa4e36@gandalf.local.home>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
        <20180705180544.7210caad@gandalf.local.home>
        <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
        <20180706142104.42fa4e36@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 6 Jul 2018 14:21:04 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> >   
> > > +				entry = &temp_rec->entry;
> > > +				kshark_set_entry_values(kshark_ctx, rec, entry);    
> > 
> > Maybe the call of kshark_add_task() can be moved to 
> > kshark_load_data_entries()
> > Just to be consistent with kshark_load_data_records()  
> 
> The problem is that "rec" is freed. That was required as part of the
> speed up.

Ah, you said kshark_add_task(), I read it as kshark_set_entry_values().
I'll look at it. But an FYI on replying. When making comments, one
usually references the code above, not below, which is where I got
confused.

Thanks!

-- Steve


> 
> >   
> > > +				task = kshark_add_task(kshark_ctx, entry->pid);
> > > +				if (!task) {
> > > +					free_record(rec);
> > > +					goto fail;
> > > +				}
