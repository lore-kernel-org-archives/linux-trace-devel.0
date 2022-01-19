Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D44C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 10:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353710AbiASKa4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 05:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240412AbiASKa4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 05:30:56 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E4C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 02:30:55 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 30so9080877edv.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 02:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=o9HikjhCDLybMhyW5Ehnj7wMN+xi+IviyUkka49PKso=;
        b=TAJZshQBJxdbKjKtyxPfAhKWIt2oBamKqRE3JFEB4A4JyxDK9pF9YVAgunbRHZBqsk
         tUfooCmRPwwRrvBI/S0OJ9JjTzv6f1IlAZhuQxovTSg+k6Cn4eR7Td5tht/4ACUcVAzq
         DV1+ZRW9RjsW/YXotN7MKjb1iw7fDUrHJgFQfBlkEHYn757thaFV1fODA8GXIrHYtCH+
         62FtcdwHrFdeaLxfJmLLOjT7yHaqFIXOLZjdXldap7mZfJwPGryZObFidaaOtM23eyZJ
         WOiPQQKKDhOpflCUv3OP93UEJMiYApFOKay1Mbamx1NkFoNXVFnfSwPp3i+FXxmvVi/y
         cv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o9HikjhCDLybMhyW5Ehnj7wMN+xi+IviyUkka49PKso=;
        b=CmojZIbRxgC85i4PtL/vMuTIkjLk4wNFsfDshuifaHwHg4bQPgPDaegy53M3MwjygD
         uSXJGM8ivEcGHb4OfEtIvau1dcK2qiOQxgWohoFDHelWLfMSsojkswYDu/HctE2Mvh+7
         pbH/HT0k0QaA3GY5kJSxQDSkKhQBEoMe2tWIe2eSctoG+BD/c7G0AgP2z8QFUDv5zXgw
         A+ufdtgioacbVvWPML0rDNCWEezT/vYdczqpPefHwZpYqyRL/+QIu5USBZQado0oJ54c
         HeY+bIHmku/+WgdRFO4qUPlz9p5R5ASKo7S/U+dbjFvtfh6JgM6aERyZDIq5DWEjWDwe
         8QyQ==
X-Gm-Message-State: AOAM530ZUem2JhGKBpndizu5h+KtRl00yEFvhvp4JnoHu6g3em50rbsR
        sLA+6engqDTfS3Jys4W5pwK+6EOpxq8=
X-Google-Smtp-Source: ABdhPJx4ss3VvpBZEuPPP9pmH99hoeHicI/nBxkJ1zDLnr/hDWxYZ8zII6jISF5sUw2qdZVZ+u9nXw==
X-Received: by 2002:a17:906:7310:: with SMTP id di16mr10106787ejc.582.1642588254439;
        Wed, 19 Jan 2022 02:30:54 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id nd36sm6262589ejc.196.2022.01.19.02.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 02:30:54 -0800 (PST)
Message-ID: <d429d850-6093-0df5-4c66-f0167b434b79@gmail.com>
Date:   Wed, 19 Jan 2022 12:30:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] trace-cruncher: Add API to set tracing CPU affinity
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220117201835.0991759f@gandalf.local.home>
 <3a60bdb7-6d2c-a912-3ef1-880ff9388a52@gmail.com>
 <20220118174019.005afcc2@gandalf.local.home>
 <20220118174146.01904fcd@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220118174146.01904fcd@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.01.22 г. 0:41 ч., Steven Rostedt wrote:
> On Tue, 18 Jan 2022 17:40:19 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>>> I guess you use 'goto err;' everywhere, because you want to stress that returning NULL is essentially exiting with
>>> error. However, so far we used just 'return NULL' everywhere and I would prefer to keep the code consistent.
>>> Maybe in a separate patch we can replace all ''return NULL;' lines with a macro that can have some self-explanatory name?
>>
>> Yeah, I was trying to match the existing code, as I'm new to this. ;-)
> 
> Oh, if you haven't noticed. I created a tracefs_instance_get_affinity() API
> as well ;-)
> 
>    https://patchwork.kernel.org/project/linux-trace-devel/patch/20220118030005.1603821-2-rostedt@goodmis.org/

Great!
Y.

> 
> -- Steve
> 
