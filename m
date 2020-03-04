Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321E2C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 18:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0187D2467E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 18:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IS+irBgk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbgCDSTp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 13:19:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52222 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727137AbgCDSTp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 13:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583345984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4YvhRWVsScu2LpRgbqsZ8hzRkIMlDStS355Rw20Agk=;
        b=IS+irBgkrUROvf0blNe/CAaCSdLe4scYI17nCjwDN2I6fc8as8zGmoIJy+2ohMoeMKhxS0
        QFullTfUP5ud0sNnXhLsjrGG2ozkNpJDaGcnd52pB+xsHanoNYftwt7MZszRbst98fBBR8
        a26aQKqPV08LSbgeEtA/lF3g7Gj07yw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-zJcxArulMbyb60Pqgro0vg-1; Wed, 04 Mar 2020 13:19:43 -0500
X-MC-Unique: zJcxArulMbyb60Pqgro0vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CEB5800D50;
        Wed,  4 Mar 2020 18:19:42 +0000 (UTC)
Received: from [10.10.122.134] (ovpn-122-134.rdu2.redhat.com [10.10.122.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68FDA5C221;
        Wed,  4 Mar 2020 18:19:41 +0000 (UTC)
Subject: Re: [PATCH v2 0/2] trace-cmd record: add --cpu-list option
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <1479846052-8020-1-git-send-email-lcapitulino@redhat.com>
 <20170103113258.17e57d1a@redhat.com>
 <20170103114530.49053eaa@gandalf.local.home>
 <20170103115406.167e508e@redhat.com>
 <20200303220745.527c57f2@oasis.local.home>
From:   Luiz Capitulino <lcapitulino@redhat.com>
Message-ID: <225c4a51-05c0-5f85-d649-335002b18a47@redhat.com>
Date:   Wed, 4 Mar 2020 13:19:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303220745.527c57f2@oasis.local.home>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2020-03-03 10:07 p.m., Steven Rostedt wrote:
> Looking through my inbox, I stumbled on this.
> 
> On Tue, 3 Jan 2017 11:54:06 -0500
> Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
>> On Tue, 3 Jan 2017 11:45:30 -0500
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> On Tue, 3 Jan 2017 11:32:58 -0500
>>> Luiz Capitulino <lcapitulino@redhat.com> wrote:
>>>    
>>>> On Tue, 22 Nov 2016 15:20:50 -0500
>>>> Luiz Capitulino <lcapitulino@redhat.com> wrote:
>>>>      
>>>>> This series adds support for a --cpu-list option, which is
>>>>> much more human friendly than -M:
>>>>>
>>>>>    # trace-cmd record --cpu-list 1,4,10-15 [...]
>>>>>
>>>>> The first patch is a small refectoring needed to
>>>>> make --cpu-list support fit nicely. The second patch
>>>>> adds the new option.
>>>>
>>>> ping?
>>>>      
>>>
>>> Thanks for the reminder ;-)
>>>
>>> I'm going to try to get to this this week, but as this is my first week
>>> on my new job (not to mention the new year), you may need to ping me
>>> again.
>>
>> I see, no rush then.
> 
> I hope you really meant that, as I really did need another ping.
> 
> I think this is a good option to have. I've Cc'd linux-trace-devel, and
> hopefully we'll get this feature added much sooner than the next 3
> years!

That's great to hear! :)

- Luiz

