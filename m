Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0413C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 14:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbiAKOZ6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 09:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240963AbiAKOZ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 09:25:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B259C06173F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 06:25:57 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i5so14259471edf.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 06:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sIQXMVPc2GH+1IzrK9zXkwMB5jEKjzVUbAHsCGbQXZE=;
        b=D0UCXz3eKr/q4Iy7n3s+OQ8YAxr8P+/iwSslpGkP0ZZksPjnkU5rn9Dq1pKrMxZvfp
         q6XbVm5Xa8PHiZUXnz1NobGLwGF1g1qMQSKEcahpjQ0KxEnfAtcjtQxOXJ4brlGU8lc+
         acmBpIgBGxTlNbHv4Nf/4DAlu4sMU5WSXSsK3vbJs2dBa/WHBDHHOo3xyJlRbx5xest5
         x35wTyBYGy2Xnhp+Jp+aRAC91fJ9g92zTnxWRo2Y0yogO+YZfhrmDPLYI8sNS56G0vOf
         0FDShZzoAkp1S39ArAJ4l3yoaLGWco4Re43JqU7vIn/B9HebtGYiHQQnUuN4/sZcKt0X
         dxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sIQXMVPc2GH+1IzrK9zXkwMB5jEKjzVUbAHsCGbQXZE=;
        b=gpA7jpdmD8dXiEi0Nt2MzxVPN902y20G7aK1l5VCfvgd3Olfgy2vCystgai/crU2VC
         8m5u0qs6ojVo/Rf4aNGewtLJDJoTxm7skDG6nswgYUZzbTjQvkdVSJnGwGIPHmCA6H/D
         TKQ66gH4JxyEIzlq6IaVd2riJbE7rNWEgYAvY9E8ZE67xhvAoHfDBvuRq+0shfWcP00M
         CJxqaMONUDox0DWsKzA8aSGl7EPOpGpWul2P7xMrhC2NDRRXvhu4RfcZRP0xnV4n2tYl
         3Yxi2EirLJKjQ9f46WV7XA6xgv4d/6L7kziS2ieLXZu9RpFksunZDnTY/LwVYjKyk7et
         ZX7g==
X-Gm-Message-State: AOAM533WpBKs11jR4Q5vzOu46g/ZPbFx/1YRRAryvlZ9yDziFx/uuzPB
        wAN0KMKB4+jJFbiG2231ZOs=
X-Google-Smtp-Source: ABdhPJz3/6LdSBbdSF41pXJfvyv4TQIcGAV1k3GrW5DgVQ5CqIIl7oJY3YVjZvOLNYP1nDMUiZC63w==
X-Received: by 2002:a50:c88d:: with SMTP id d13mr4722989edh.316.1641911156054;
        Tue, 11 Jan 2022 06:25:56 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id z19sm2953292edd.78.2022.01.11.06.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 06:25:53 -0800 (PST)
Message-ID: <7af1fd18-d48b-5327-3eed-bd2b60bc46be@gmail.com>
Date:   Tue, 11 Jan 2022 16:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
 <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
 <20220110102010.5c41b336@gandalf.local.home>
 <ddda1b3a-c626-8733-5d74-0d29d768e7a5@gmail.com>
 <20220111090035.3cf11479@rorschach.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220111090035.3cf11479@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.01.22 г. 16:00 ч., Steven Rostedt wrote:
> On Tue, 11 Jan 2022 15:07:06 +0200
> Yordan Karadzhov<y.karadz@gmail.com>  wrote:
> 
>> On 10.01.22 г. 17:20 ч., Steven Rostedt wrote:
>>> On Mon, 10 Jan 2022 15:32:16 +0200
>>> Yordan Karadzhov<y.karadz@gmail.com>  wrote:
>>>    
>>>> Hi Steven
>>>>
>>>> On 18.12.21 г. 1:26 ч., Steven Rostedt wrote:
>>>>> From: "Steven Rostedt (VMware)"<rostedt@goodmis.org>
>>>>>
>>>>> Add a set_affinity API that can let the user set what CPUs to enable
>>>>> tracing on.
>>>> For the sake of completeness we will need APIs to 'clear' and 'get' the CPU affinity as well.
>>> For "clear" you mean to avoid a CPU(s), not clear the mask, right?
>> I mean clear the mask. This will be a very simple method. The only argument will be the instance. And inside the method
>> you just call 'tracefs_instance_file_clear()'. The 'get' method can return the bit mask of the CPUs.
>>
> But why would anyone clear it? It doesn't make any sense. This mask is
> the CPUs that tracing is allowed on. By clearing it, you basically
> stopped all tracing. If anything, it would confuse people. I honestly
> do not know of a single use case (besides testing the tracing
> infrastructure) for clearing the entire mask.
> 
> It would be similar to clearing the affinity mask for a task or
> interrupt. If anything, that could harm the system. I'm not even sure
> it's allowed (it would fail if tried).
> 
> Now, I could see clearing specific CPUs, and that would be useful. Say
> you want to trace the entire system, but you dedicated a CPU for the
> tracing application. It would make sense to clear the CPUs that your
> tracing application is on and leave all others intact. That way the
> tracing application doesn't affect the results as much.
> 

Sorry about my confusion, you are right.

Clearing the mask or setting all bits to 0 makes no sense. What I wanted to have is the exact opposite. I want an API 
that restores the default configuration (sets all bits to 1).
Maybe 'reset' is a better name in this case.

Thanks!
Yordan


