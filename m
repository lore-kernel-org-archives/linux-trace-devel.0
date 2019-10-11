Return-Path: <SRS0=hDql=YE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA88EC47404
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 14:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D85C20679
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Oct 2019 14:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d942ddMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfJKOL0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Oct 2019 10:11:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41563 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbfJKOL0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 10:11:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id q9so12105150wrm.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2019 07:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jqCDOz0ZyYjNXY1JyuliMSaVMwm+HCqBGKu2ZWihyDw=;
        b=d942ddMZQAOAxrXlMfOY1H6wN3VMfA9GTpFlb1e3+7vCPuSNGEOmEbTxUzne/0N1Tz
         ANic/Vdzydv5tFQq1WrQ7xFoSJVCDlFMPa1a9g5sBfU4KVIY1wx9aEamcnrhn20LaN3h
         Vlda4KFBuD0Neo0CCCi99XmdaIjZQ9Ak8T4zb5ytMkeEsKeW66gbQ06eyyW4/puARMwh
         6E9LdEozNU1qY3NB1F0J1cMdxHlkIiJRb4auYA+/Dap2aSLSRKO4ZpTDI13VUNK04yHM
         MEtVhr1wdEsHXsw3jw0p+tZfUNS45yRL74TvmKk3ZnXlT3bDTdYak+yASwtIYMgM3TV3
         h0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jqCDOz0ZyYjNXY1JyuliMSaVMwm+HCqBGKu2ZWihyDw=;
        b=XE289jsEAL6u8PjLvEoH5Y02BTJcK6vX+qw5iJRP2TfhaV8yywAHWFoUwPGL+Ja6FT
         ZldZ+zvk3i3ibT3+tGLfBmTuCXj/Gl0jblfFmKgLuZV5461HiY7sAL6lNAtok582fZOQ
         oVNffSdLxz27qtb3OQSAgfSxggWx0dcocYs5QkkDIpo1SXh5QDVZtmkRYhhv51JCZWK0
         m4GpaDVmNh2dbdZlF5tNoczB8VtidobOFe6dhpk7EhAqtzySWMk7nOn0T8q4zWtM4JLS
         gXCVdkuQx9EwTQqjiCwt0KYy7GKCYZghbh47EfV9u4S6A/uMslI/0LrGF++dI+tbP90E
         G0IA==
X-Gm-Message-State: APjAAAWVRxuo4qhkUD0gnDMny/teuiSE7lDFR2P4VP0y2+krmBQXN2Wl
        wt4WcFkbZ40Plk+uiLUa4u8=
X-Google-Smtp-Source: APXvYqz9+kTvvn/kZdV1bZXY3nl4szGlt7cGOyEwicVP09gujAJJlQnYV6Wdt8MKl2Z2RZ4fgYgDaA==
X-Received: by 2002:adf:a516:: with SMTP id i22mr14474607wrb.273.1570803083761;
        Fri, 11 Oct 2019 07:11:23 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b186sm12798103wmd.16.2019.10.11.07.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:11:23 -0700 (PDT)
Subject: Re: [PATCH 0/4] Fix KernelShark appearance on dark color schemes
To:     Steven Rostedt <rostedt@goodmis.org>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>
References: <20191010212429.469155-1-mike.rudenko@gmail.com>
 <20191010180205.06aab874@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <9a5c1135-12b9-27c2-159a-7468b0877650@gmail.com>
Date:   Fri, 11 Oct 2019 17:11:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010180205.06aab874@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.10.19 г. 1:02 ч., Steven Rostedt wrote:
> On Fri, 11 Oct 2019 00:24:25 +0300
> Mikhail Rudenko <mike.rudenko@gmail.com> wrote:
> 
>> Currently a few widgets in Kernel Shark UI use custom stylesheets,
>> unconditionally setting their background or text color (but not both!)
>> to hard-coded values. This has a side effect of widget text being
>> poorly readable on some color schemes (e.g. Breeze Dark, and dark
>> schemes in general). This patch series tries to address this issue.
>>
>> The first three patches are trivial: they ensure that whenever the
>> background color of a widget is set to white via stylesheet, its text
>> color is set to black.
>>
>> The fourth one changes "inactive" marker selection button style to
>> system default, making it look clickable on all color schemes.
>>
>> Mikhail Rudenko (4):
>>    kernel-shark: Set text color to black in KsDualMarker's QLabels
>>    kernel-shark: Set text color to black in pointer position QLabel
>>    kernel-shark: Set text color to black in KsTraceGraph's axes labels
>>    kernel-shark: Change KsDualMarker's inactive button style to default
>>
>>   kernel-shark/src/KsDualMarker.cpp | 11 ++---------
>>   kernel-shark/src/KsTraceGraph.cpp |  6 ++++--
>>   2 files changed, 6 insertions(+), 11 deletions(-)
> 
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> Yordan,
> 
> If you are fine with these patches, could you pull them in and push
> them to the repo?

Hi Mikhail,

Thanks a lot!
I am pushing the patches.
Is is possible to send us a screenshot? I am curious to see how 
KernelShark looks on your dark color scheme.

cheers,
Yordan

> 
> -- Steve
> 
