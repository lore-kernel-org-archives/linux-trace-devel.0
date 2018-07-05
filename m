Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753397AbeGEOro (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 10:47:44 -0400
Date: Thu, 5 Jul 2018 10:47:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180705104740.188490bb@gandalf.local.home>
In-Reply-To: <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 4 Jul 2018 14:39:01 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >   /**
> >    * @brief Load the content of the trace data file into an array of
> >    *	  kshark_entries. This function provides fast loading, however the  
> 
> Actually , after applying the patch for trace-input.c and this patch on 
> top kshark_load_data_entries() becomes slower than 
> kshark_load_data_records(). Just make this clear in the description of 
> the functions.

So what should the purpose of this function be stated here then?

"This function provides an abstraction of the entries from the raw data
that is read." ?

-- Steve


> 
> > @@ -521,9 +587,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> >   				struct kshark_entry ***data_rows)
