Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8A5C433E7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483F3208D5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 12:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsLiNyue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388435AbgJLMaZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388334AbgJLMaZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 08:30:25 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3122FC0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 05:30:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b193so13202118pga.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 05:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tNeAJUdIVMTAla6D+E2Zq7NH5DEHNWqtLJ6ArsRCFgA=;
        b=IsLiNyueQg3M7jajuJZ+ETbF5UM5A8YcLLIbp0NKtLR4mMOlc24mKXoJW7IdK/l0sm
         cZL9vZ5U+s6etpaVzGStCxe0LAxDJZf1FZNHnTpXz6VBfP8omTeIhxSDUIs9gdxP8Pvk
         JvikQAWsKRNf+5y8HM9JzPWtdPqrE4Hv7AbMQxpI1rVXukxSuoNdpNREeRAi7MVBLN6u
         26VZ88/dgySvCC/0v4Ml9tcvChRd2E2eiAbSymgKQR+7DEDVL7wgW+5QHNo+b2UzVH6e
         DARcu5xgG92zKLAuQjkujkUrkeO63Z1ikj10fO8/NoN0fLc3xEd89IXaZRdf3qD+GfWa
         yjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tNeAJUdIVMTAla6D+E2Zq7NH5DEHNWqtLJ6ArsRCFgA=;
        b=B07TkS9RoE+M1J8l9HleG8ypX32gASgdqrEwULCv/homh/hDVqM8F9WQVAnfdHaDXF
         ePK2eQG3c//ZgQETn6cQBw2Kp59T8osfaMPOAu7MD66LaF1PIz9LHb4Yf6P9Zsi+JtnU
         OVOjM/8aYqbV71Y6ZtqZcQ4xxWhOIe3xEpWb5rjeKgZRMY5sj4eXS2vibot6aT0ZCQ/w
         oLOSsD4HXjrj/qJqvCK6VUIjuRC1sG10jTo0cZyilRRC/mj+pZMYU1tLGuO5910WXYEQ
         ACveaZgWIdk+JWIvCeraLH59/9A7r9jZ4bkAuo6XmU2907RjeDhRwY+8pYEpNPKfHNGi
         +dIg==
X-Gm-Message-State: AOAM532NJjGlBEwcvlotzAQjUlZ5xEGEmjulxRPhMFpaCS8/AL9ncXyg
        CfDi3XOLe10Bv1QBb+9j9Kbeh6MmY7OyARFwl6k=
X-Google-Smtp-Source: ABdhPJxwLRmQ0ZoTKTsZChLDubtzqaXhgbrekT9gyd8pXl6iWzKv2WxrnDfBi5w/Fh76eixok9G9jA==
X-Received: by 2002:a17:90a:7f8b:: with SMTP id m11mr19679086pjl.121.1602505822992;
        Mon, 12 Oct 2020 05:30:22 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id s8sm19249660pjl.41.2020.10.12.05.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 05:30:22 -0700 (PDT)
Subject: Re: [PATCH] Documentation: Fix include level of Makefile scripts
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org
References: <20201008071858.96786-1-sztsian@gmail.com>
 <7897620c-3039-5e4f-09d9-41606673fa63@gmail.com>
 <20201009105441.3c92e560@gandalf.local.home>
From:   Zamir SUN <sztsian@gmail.com>
Message-ID: <4116a10f-d3f8-25a0-29fb-62835b40e475@gmail.com>
Date:   Mon, 12 Oct 2020 20:30:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201009105441.3c92e560@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10/9/20 10:54 PM, Steven Rostedt wrote:
> On Thu, 8 Oct 2020 15:30:08 +0800
> Zamir SUN <sztsian@gmail.com> wrote:
> 
>> Note, this patch is for libtraceevent.
>>
>> And I think it makes more sense to port the missing
>> scripts/utilities.mak by the maintainer rather than sending a patchset
>> with lots of historical commits from kernel, so I did not include that
>> part here.
>>
>> HTH.
> 
> Thanks!
> 
> I reverted the copy and brought over the history of the Makefiles, scripts
> and include headers. I also included utilities.mak.
> 
> When this becomes something that can be installed as a package, I'll give
> it an official tag: libtraceevent-v1.1.0
> 
Hi Steve,

Thanks. As of the following commit, I can compile the library without 
extra patch now.

commit 5dd505f3aba255c5fbc2a6dbed57fcba51b400f6 (origin/libtraceevent, 
origin/HEAD)
Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
Date:   Fri Oct 9 10:56:07 2020 -0400

     lib traceevent: Remove trace-cmd references from Makefile


-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
