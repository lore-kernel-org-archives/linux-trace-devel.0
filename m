Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6122EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Apr 2022 16:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbiDMQH7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 12:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbiDMQH6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 12:07:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13F6644CC
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 09:05:36 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b15so2974827edn.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 09:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7OQ9sOWKaK+Z74v9fAuoG4JgZZmXIarNY7Lrm0D9uXg=;
        b=Prmsda8hlMF9661o39XbQ3HKYhKDA+RP1rF8E9tYAW+P1dJFX09hXHPLJWLpx0h7D+
         1NABaI4IsUnun/QQUx3fFLjO8BZHTmzD4kZR32fuuxFIeFZHTXQFy7fEDVZdYHEm2J4h
         d5q6LbniE/IXWP9Hqqb7cuSY4zuICIWKc8yg0/fj+kSIZgO0cOTHG/ZFPVbkFwocz375
         47KotBFr0dzDQmC/La4hUKeyE9XtLNRE2Aj84N3ZP0bOKCo8sbW1SYYy4IL5kck0zpnw
         A8enhwRw/sA15G9QuaprupN4rnideNBRc/+3bJWuC6wzSOWyECz/mneblFP4mGB12MfP
         tkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7OQ9sOWKaK+Z74v9fAuoG4JgZZmXIarNY7Lrm0D9uXg=;
        b=kh12KenETKe3/YDEdCjDfVWqkwp6xQ13xc4+c5EtnMjVElQVsgT2rXLOq+smh7+62y
         tUp1DmNEwylLNjh7yjpZn0rMoJy/EIMOkFH4jWrzjIv8eXoPbYpazgfwDNghsPZnPE9j
         hJo5oAqHHsb9EYMQypsIKhruidGEeu0kTyDi1+zF6OaqEv68JwznGu3Ef5XCRgeIrTu7
         7qW+eGCjYsjvWQXqXSjhPx9yNsV8THQVMEA8LVTJFoe/+NA+jIo+wLqvCH7Z1MPFNw3A
         ZPiS5dgyLzu9lRyv9WrcmrXetagRGvpXhjJ4QoWOjO3Bh3V+Ku6RTP9WHH1C4zWHKbzb
         Nd1g==
X-Gm-Message-State: AOAM532Ox5FF5J4BhNtmxCnsmbT2vw2QWwYGqycs5bx5nHP7BCY8WUKs
        c6tXIWkoQ9ZW0XQWdGKtz8Y1izJEr9Q=
X-Google-Smtp-Source: ABdhPJzzTydocwJE6nzD1gKvLNdWhJiWu2REDg1pGlTHnrzflqkuNi3EkYFY+dwkrBgUBzDyDJfUsg==
X-Received: by 2002:a50:c00a:0:b0:418:f10f:b27c with SMTP id r10-20020a50c00a000000b00418f10fb27cmr43680047edb.204.1649865935205;
        Wed, 13 Apr 2022 09:05:35 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id m20-20020a056402431400b00419315cc3e2sm1370558edc.61.2022.04.13.09.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 09:05:34 -0700 (PDT)
Message-ID: <7040d148-a2ab-d012-10c6-fc4d3fbaeef5@gmail.com>
Date:   Wed, 13 Apr 2022 19:05:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] setup.py: fix string <-> int comparison
Content-Language: en-US
To:     John 'Warthog9' Hawley <warthog9@eaglescrag.net>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220409002155.1346141-1-warthog9@eaglescrag.net>
 <d5569c98-a41a-ebad-dafe-ff0819361fb6@eaglescrag.net>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <d5569c98-a41a-ebad-dafe-ff0819361fb6@eaglescrag.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks John!
Yordan

On 9.04.22 г. 3:23 ч., John 'Warthog9' Hawley wrote:
> Sorry also should have specified this is trace-cruncher specific
> 
> - John
> 
> On 4/8/2022 5:21 PM, John 'Warthog9' Hawley (VMware) wrote:
>> Slightly older (read: python 3.6ish) seem to treat the language_level
>> object as an integer all the time.  If you end up passing the version
>> in as a string (with the 's) it ends up doing a string to int comparison
>> and throws an error.  Newer python will deal with the non-matching
>> typing fine and this isn't an issue there.
>>
>> So minor fix to be slightly more correct with relation to older python
>>
>> Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
>> ---
>>   setup.py | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/setup.py b/setup.py
>> index 21c627f..58561cf 100644
>> --- a/setup.py
>> +++ b/setup.py
>> @@ -74,7 +74,7 @@ def main():
>>                             sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
>>                             libraries=['traceevent', 'tracefs'])
>> -    cythonize('src/npdatawrapper.pyx', language_level = '3')
>> +    cythonize('src/npdatawrapper.pyx', language_level = 3)
>>       module_data = extension(name='tracecruncher.npdatawrapper',
>>                               sources=['src/npdatawrapper.c'],
>>                               libraries=['kshark'])
