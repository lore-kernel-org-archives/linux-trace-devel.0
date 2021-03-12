Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCF1C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Mar 2021 06:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A094864F80
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Mar 2021 06:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhCLGqm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Mar 2021 01:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhCLGq0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 01:46:26 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B47C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 22:46:25 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lr13so51310661ejb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 22:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nHUIyUBwD1YKKbQFQL9y+faF3u+FPUlS+DdA59A2axw=;
        b=pucNW1edHnhQdoVeU24roM0YtjGIP3MBYE3q1H2s0CDd7C6gE3Ca4ZMKV69fLh5O13
         RSeQwBYi5UDgX2lKCyqo+n86c1cLuxTrPQceaU0YNnbaDUaBv41XXluLlqTiVArapJvT
         /q3kdCkN+My/9oYJqnKWM9rUIuWpXiX+vQQgh6axp2dWgF8Ql+8KTdWbk2jnXHa9gfU+
         CuY+n8sFl4KR8hUMtlUSvC5KeSNMTO7h1wz9bAB8+Dsn1MjvjQEu7/JQC5YuxAhgvrP1
         3F4crFC+IJKQPts27XRF1z4EEXL061L0GOFpDwCn+Yrt9Z8GIzI6RUy58kNrmDi3BCP0
         atWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nHUIyUBwD1YKKbQFQL9y+faF3u+FPUlS+DdA59A2axw=;
        b=OzPl7kJeIvmScon0M0Rlo1dAtEZNhEqesZNIEx/ZR8Fn9Ue8K0GIKBWf0AF7bADYN0
         LArqPzjjU+HCe4yNPoWzu9SPBI7v0ssD4jAv0Igmg/FOoBZhIcCCBqY1BFKEA6UnVIbT
         xRK0adFFiUKyhBIdOGVyXq8lUitwyxxuUQNfsej4aAXkZ5eAxfEAwjFaXD84XwCcSDee
         BACw1MH18UWeoO3dsEkOH+ummSLTN9jtwFPxLHbJ2cy2ZKnmKNdvEyHlbuxXBIjXG2hQ
         dfHmnYAvneYtxnKaOaDe0dtXmawVEUVXXrp86rdLROXfRB+ZOH1AWWhM5DK1YlXZx5iB
         lTNw==
X-Gm-Message-State: AOAM531U2MAc+GCHVW5VbE6ycNAzzh1lpzW49Fv32cA296APNqmYWXKy
        zhXhUO3+p1oNB6xhs1bJSpCT59c6a+TKqA==
X-Google-Smtp-Source: ABdhPJwoGnEhydlmfX/NpwRAtuCAF8eyRky247V3+JR+iOu4g2Hlt8gbvBJpAo3rgUVkMIPNCJe5YQ==
X-Received: by 2002:a17:907:72ce:: with SMTP id du14mr6911945ejc.301.1615531583599;
        Thu, 11 Mar 2021 22:46:23 -0800 (PST)
Received: from [192.168.0.108] ([84.40.73.174])
        by smtp.gmail.com with ESMTPSA id h24sm2433893edt.25.2021.03.11.22.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 22:46:23 -0800 (PST)
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
To:     Michal Sojka <michal.sojka@cvut.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <87mtv97nlj.fsf@steelpick.2x.cz>
 <20210311145059.27147-1-michal.sojka@cvut.cz>
 <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
 <87k0qd7evn.fsf@steelpick.2x.cz>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <1aaeb84b-2820-0818-4ab6-fcfd7b5fa52c@gmail.com>
Date:   Fri, 12 Mar 2021 08:46:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87k0qd7evn.fsf@steelpick.2x.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Michal,

On 11.03.21 г. 19:57, Michal Sojka wrote:
> Hi Yordan,
> 
> On Thu, Mar 11 2021, Yordan Karadzhov (VMware) wrote:
>> In your case the installation fails to install the policy file used by
>> Polkit. Note that this doesn't mean that the kernelshark installation
>> itself fails.
> 
> Yes, I know, but when something fails, users are confused ;-)

You are right here. We have to think how to make this message look more 
like a warning.

> 
>> As far as I know the policy file can only go to a special locations so
>> that Polkit can find it. Otherwise it will have no effect (I may be
>> wrong on this).
> 
> You're right. I looked at polkit sources and it really seems that only
> one location is supported. It is determined at configuration time so on
> some systems it may be different from /usr/share/... I'm talking
> specifically about NixOS, but it already has the patch I sent.
> 
> So I leave it up to you whether to apply the patch or not. I think that
> supporting seamless installation into $HOME is useful if one wants to
> quickly use a newer version not available in their distribution.

Building, installing as root and testing the latest version shouldn't 
cause any problems/conflicts on your system. Note that there is a script 
in kernel-shark/build called "cmake_uninstall.sh". It is guaranteed that 
this script removes every single file that has been installed.

And BTW from the patch I see that you still use the old version that 
comes together with trace-cmd. If you are keen to try the latest 
version, checkout this one:

https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/

This is a brand new version that has a lot of changes under the hood and 
needs user testing. We will be extremely happy to receive bug reports ;) 
or patches for this new version.

Thanks!
Yordan

