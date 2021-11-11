Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D18FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 732AB611AD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhKKIPm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhKKIPm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 03:15:42 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B59DC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 00:12:53 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g14so21038278edz.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 00:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BWuwJVG6B+b+2fDExbBS/EAOivXLuw/Tc4NJmUXC858=;
        b=I1RAeRyoSJ4k9iLg2xAJ/AS9g5mIKihXN7YCD6U+2HQRyCPnhZIUYDqRLEsiBXtzj4
         dcPRKDBjIa6SxTMb7ld481gxlaVGS0bBYlogs0rPJvuFJWlSiXasQ+6gLFLqPgTwhKcd
         JKMeWkpWCipyIO1eSDHiPYsJTSTNGk8XsSA2bzYvmkWgtrrjNu8jDhBAvwcw3xEz/Luf
         YczGulb9QxzSVXMeAiX9UR8Ambqfd3Pc0wKXEWlkoXlLwm9YrwIpxrk4+dqLjyTxwDEJ
         GrV9DM3l0eXIcI4u9CMmKjdjeYvfFl6btR4cVJqyR8OnzSmTHi3mk/e1ixj4zBTi/O5P
         VLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BWuwJVG6B+b+2fDExbBS/EAOivXLuw/Tc4NJmUXC858=;
        b=OnXPTrXWHeAeKbhxpUcnjvKTof0D33s+rpeSUbQdIAP5fw3L6hBYQH1BVW86pRpxzH
         Y8LGJL8B1jDA7+9IMnHv6n4VhBWgNmT5MqR27g6pZeAGo3iKVyA5kTztgQFzLyrTSIOS
         jmHUqCwmUhovYVUnAM08Vfc9UFmxSPZN+4lbpV2efXAMKCo59XRutwu6dCuf7hQPhfMf
         xjzIJITV5NMhI+MnMA95n9vBQ9JsLGvgzCK5Mlkrdr0jmdYLOhhDpKe9gWoaU2zcgiq3
         CkXJO5ledv+y32QBY+v4L6QOnaKUjiW1gwcS7PbCF76gh4krgl1X+KP3VQdPH45Elrg+
         dLMQ==
X-Gm-Message-State: AOAM531FdLt2YxF3Ylk3o5wDso4yNXjOQ1jbaqfdWWFMGRisD8JWMLpk
        MWSC6PFTGNQFS4C2w7YzVCIvPNsec+c=
X-Google-Smtp-Source: ABdhPJwaGC9LcZxR0m51Wsq8aG+y8tzC0dGpLOyl0853CcYSw6CJSDifpGXPT2/ib586zWJ3kYpkTQ==
X-Received: by 2002:a17:906:ecac:: with SMTP id qh12mr6846773ejb.377.1636618371656;
        Thu, 11 Nov 2021 00:12:51 -0800 (PST)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id v6sm1063656edy.83.2021.11.11.00.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 00:12:51 -0800 (PST)
Message-ID: <47ed3cdf-5f2e-1823-b933-e23b604e208b@gmail.com>
Date:   Thu, 11 Nov 2021 10:12:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] trace-cmd: Add Requires: libtracefs to libtracecmd.pc
 file
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20211109111426.7639b2a6@gandalf.local.home>
 <db8be415-bb25-a2fe-1d30-8e4a446154f7@gmail.com>
 <20211110111729.41a7eb6b@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20211110111729.41a7eb6b@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.11.21 г. 18:17 ч., Steven Rostedt wrote:
> On Wed, 10 Nov 2021 16:12:12 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> On 9.11.21 г. 18:14 ч., Steven Rostedt wrote:
>>> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>>>
>>> In order to not have users of libtracecmd having to also include the
>>> includes and libraries for libtracefs and libraceevent, add a requires
>>> field for libtracefs to the libtracecmd.pc file. As libtracefs requires
>>> libtraceevent, it will pull that one in as well.
>>>
>>> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>> ---
>>>    libtracecmd.pc.template | 1 +
>>>    scripts/utils.mk        | 1 +
>>>    2 files changed, 2 insertions(+)
>>>
>>> diff --git a/libtracecmd.pc.template b/libtracecmd.pc.template
>>> index dc41076e..bcf4e39d 100644
>>> --- a/libtracecmd.pc.template
>>> +++ b/libtracecmd.pc.template
>>> @@ -6,5 +6,6 @@ Name: libtracecmd
>>>    URL: https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
>>>    Description: Library for creating and reading trace-cmd data files
>>>    Version: LIB_VERSION
>>> +Requires: libtracefs >= LIBTRACEFS_MIN_VERSION
>>
>> BTW this works also without the 'lib' prefix:
>>
>> Requires: tracefs >= LIBTRACEFS_MIN_VERSION
> 
> I just tried that on Fedora, and get this:
> 
> # pkg-config --libs libtracecmd
> Package tracefs was not found in the pkg-config search path.
> Perhaps you should add the directory containing `tracefs.pc'
> to the PKG_CONFIG_PATH environment variable
> Package 'tracefs', required by 'libtracecmd', not found

OK, it looks like what matters is really the name of the .pc file (and the 'Name: ...' line). I was confused because 
'json-c.ps' has no 'lib' prefix. Looking into

/usr/local/lib/x86_64-linux-gnu/pkgconfig

I see that most of the configuration files do not have 'lib', however there is also a number of files starting with 
'lib'. I wonder if there is some rule about using this 'lib' prefix.

Thanks!
Yordan


> 
> -- Steve
> 
