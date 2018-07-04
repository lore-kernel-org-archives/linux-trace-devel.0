Return-Path: <SRS0=h6hK=JU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43361 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932576AbeGDLR3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jul 2018 07:17:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id u11-v6so3776983eds.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Jul 2018 04:17:29 -0700 (PDT)
Subject: Re: [PATCH 0/3] kernel-shark-qt: Merge
 kshark_load_data_records/entries()
To: Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20180703162130.082810105@goodmis.org>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <da0c7baa-2845-7873-3015-b250dd93e79e@gmail.com>
Date: Wed, 4 Jul 2018 14:17:26 +0300
MIME-Version: 1.0
In-Reply-To: <20180703162130.082810105@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  3.07.2018 19:21, Steven Rostedt wrote:
> This works to consolidate the functions kshark_load_data_records()
> with kshark_load_data_entries(). It adds some helper functions
> for the two to use to simplify the code.
> 
> Note, doxygen warns that struct rec_list is not documented. Really?
> Such a simple structure doesn't really require documentation. Is
> there a way to shut it up? Or I can just add code to say
>   /** Shut doxygen up! ;-)

Yes, you can do

//! @cond Doxygen_Suppress

struct rec_list {
	struct pevent_record	*rec;
	struct rec_list		*next;
};

//! @endcond

Another solutions is to turn off all warnings. This can be done by adding

  WARN_IF_UNDOCUMENTED = NO

to doc/dox_config

On the other hand, do we expect the normal users to build doxygen 
documentation, if this documentation is available at 
http://kernelshark.org? So maybe we can tolerate having some warnings.

Actually this reminds me that there is a third solution. We can make 
this warnings invisible for the normal users by redirecting the 
doxygen's stderr to a file.

What do you think?

Yordan


> Yordan, please review these.
> 
> Steven Rostedt (VMware) (3):
>        kernel-shark-qt: Move declarations to top in datafilter.c example
>        kernel-shark-qt: Consolidate load_data_entries and load_data_records
>        kernel-shark-qt: Add helper function to find the next_cpu in kshark_load_data_*()
> 
> ----
>   kernel-shark-qt/examples/datafilter.c |   5 +-
>   kernel-shark-qt/src/libkshark.c       | 253 ++++++++++++++++++++--------------
>   2 files changed, 151 insertions(+), 107 deletions(-)
> 
