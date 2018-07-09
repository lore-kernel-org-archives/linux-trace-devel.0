Return-Path: <SRS0=sAIo=JZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:41055 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933535AbeGIPyv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jul 2018 11:54:51 -0400
Received: by mail-wr1-f49.google.com with SMTP id j5-v6so5003942wrr.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Jul 2018 08:54:50 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180703162432.316240087@goodmis.org>
 <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
 <20180705180544.7210caad@gandalf.local.home>
 <415f299e-9cb1-5044-927f-0a653bf0b356@gmail.com>
 <20180706142104.42fa4e36@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3d4050b1-47d4-12d8-4828-6187129e5c4a@gmail.com>
Date: Mon, 9 Jul 2018 18:54:47 +0300
MIME-Version: 1.0
In-Reply-To: <20180706142104.42fa4e36@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  6.07.2018 21:21, Steven Rostedt wrote:
>>> +
>>> +				/* Apply event filtering. */
>>> +				ret = FILTER_NONE;
>> Opps, I made a bug here. It has to be
>> 				ret = FILTER_MATCH;
> Can you send a patch. I don't want this to be a fix. That should be a
> separate patch.
> 
> 

Yes, I will do this.

Thanks!
Yordan
