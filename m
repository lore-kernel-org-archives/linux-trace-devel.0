Return-Path: <SRS0=sAIo=JZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43219 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933416AbeGIPy5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jul 2018 11:54:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id b15-v6so11532480wrv.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Jul 2018 08:54:57 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180703162432.316240087@goodmis.org>
 <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
 <20180705180544.7210caad@gandalf.local.home>
 <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
 <20180706142440.4d913909@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e2fabd00-4eea-097f-7750-dcc83fcca6ba@gmail.com>
Date: Mon, 9 Jul 2018 18:54:54 +0300
MIME-Version: 1.0
In-Reply-To: <20180706142440.4d913909@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  6.07.2018 21:24, Steven Rostedt wrote:
> On Fri, 6 Jul 2018 15:46:54 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>> --- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.h
>>> +++ trace-cmd.git/kernel-shark-qt/src/libkshark.h
>>> @@ -33,6 +33,9 @@ extern "C" {
>>>     * info etc.) is available on-demand via the offset into the trace file.
>>>     */
>>>    struct kshark_entry {
>>> +	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
>>> +	struct kshark_entry *next; /* MUST BE FIRST ENTRY */
>>> +
>> Correct, thanks!
> 
> BTW, I was going to ask. Do you use entry->next elsewhere (to get per
> cpu lists)?
> 

Yes, I am using it.

Thanks!
Yordan


> -- Steve
> 
