Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8560C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E9B120643
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 17:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qiq/1sXw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfCKR4B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:56:01 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:37539 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfCKR4B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 13:56:01 -0400
Received: by mail-wr1-f43.google.com with SMTP id y15so4360700wro.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 10:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k3VyCGjOYhRFOV4km2leBoTpmgYsL3nv7EDjtvu46u0=;
        b=qiq/1sXwcjft/5Lv7CZZQHkyp9aWguez4iRLUMx83KpB2W7WMF2/lnpEec0b2m6y0O
         vnFWEGnQlUpUgMNZIbSRxnrVHy3VXA18hw+U9Shp7ErWk2vlPtc+idEjCURnzi9yOaKb
         37XyY3riI9hgYfcvornP5Nm0dCIo48kxAuWN2olJoimBIoL6AAsJmcdJnSNCcGbMsySu
         9bEQkdIukntBLY/gBPKnaf/+SQzZbDnE2Yse9k7jDzvPcum009UZ6YO3a+7moNbMG+KA
         6xjDrSJB66auLgYq2vAdfBXplrxVlqusqaJOz3Bweba3gDp1dbvAlxS8LiEeYJMFMMI6
         7q9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3VyCGjOYhRFOV4km2leBoTpmgYsL3nv7EDjtvu46u0=;
        b=NOreEH1dSkBjBns79t7oWiVXfxbBaCS5B+TpzZ4et9QpZDihMPiyHqcZfloJ/LHzGm
         dy3y6WM07J6bDEyQPp3sl9k9PHQ7DSMjTwbXmNwOAbJO03K4APxnbqkmM1JQhgH1mtXF
         Bn4xStKgOu/C/43Lmkq9BxlQpFIEe19pDlbMJOVBmcFGhJpUmJIWTQS6CMzgbX5S9kVA
         xOnD7QzjarfH3+ngTQJDGNST5gUXInMYanN/4A3kLY2SuBCt75VpGexylanN9PudoHeY
         Gf432TzSnTDaR8fzowPlEfMg6JAI8byBKrvW0R0D4/tMC5sUbYdWk4y13ccZ7EVgPrLp
         lX8g==
X-Gm-Message-State: APjAAAVTqn0uibodtBIYm8vX/jjLD0Rc2Aw2JzNpstx905efDj9F8c1g
        a1avK0oX41lFz5YSLFd5Xu8aMl3bXq0=
X-Google-Smtp-Source: APXvYqxivQycY3dqaCrFf+DRaa5iZj/zwhN1Ua4qvOgN5yjMJOgu/62WmwNXbCQ31TppySl4MkzLWg==
X-Received: by 2002:a5d:4ac6:: with SMTP id y6mr11122380wrs.84.1552326959167;
        Mon, 11 Mar 2019 10:55:59 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id u14sm11072936wrr.42.2019.03.11.10.55.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 10:55:58 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
 <20190307154316.19194-5-ykaradzhov@vmware.com>
 <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com>
 <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com>
 <CAE0o1Nv5g6wujxY8ey2mQ72kk977s7tCWq9Hcab1zfNU3rNOVg@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f4a51b16-446a-a426-a8b4-71365b8829c4@gmail.com>
Date:   Mon, 11 Mar 2019 19:55:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAE0o1Nv5g6wujxY8ey2mQ72kk977s7tCWq9Hcab1zfNU3rNOVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.03.19 г. 15:44 ч., Slavomir Kaslev wrote:
> On Mon, Mar 11, 2019 at 3:20 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
>>
>>
>>
>> On 11.03.19 г. 14:09 ч., Slavomir Kaslev wrote:
>>> On Thu, Mar 7, 2019 at 5:44 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>>>>
>>>> const char *lib = plugin.toStdString().c_str();
>>>>
>>>> This line is a bad idea because the returned array may (will) be
>>>> invalidated when the destructor of std::string is called.
>>>>
>>>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>>>> ---
>>>>    kernel-shark/src/KsUtils.cpp | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
>>>> index 34b2e2d..d7b1753 100644
>>>> --- a/kernel-shark/src/KsUtils.cpp
>>>> +++ b/kernel-shark/src/KsUtils.cpp
>>>> @@ -439,7 +439,7 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
>>>>
>>>>           auto lamRegUser = [&kshark_ctx](const QString &plugin)
>>>>           {
>>>> -               const char *lib = plugin.toStdString().c_str();
>>>> +               const char *lib = plugin.toLocal8Bit().data();
>>>>                   kshark_register_plugin(kshark_ctx, lib);
>>>>           };
>>>>
>>>> @@ -474,7 +474,7 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
>>>>
>>>>           auto lamUregUser = [&kshark_ctx](const QString &plugin)
>>>>           {
>>>> -               const char *lib = plugin.toStdString().c_str();
>>>> +               const char *lib = plugin.toLocal8Bit().data();
>>>>                   kshark_unregister_plugin(kshark_ctx, lib);
>>>>           };
>>>
>>> Doesn't the new version have the same problem with the temporary QByteArray?
>>>
>>> How about saving the data in a local std::string/QByteArray variable?
>>>
>>>                  std::string lib = plugin.toStdString();
>>>                  kshark_register_plugin(kshark_ctx, lib.c_str());
>>>
>>
>> Hi Slavi,
>>
>> As far I can understand toStdString() will create a fresh std::string
>> and this string will has its own copy of the characters. However, this
>> copy gets out-of-scope as soon as we hit the semicolon of the line.
>>
>> My understanding was that toLocal8Bit().data() makes no copy so the
>> array will go out-of-scope only when the QString is destroyed.
> 
> I did some digging into QString's implementation. From my reading of
> the code, toLocal8Bit() calls into qt_convert_to_latin1()[1] which
> does allocation, copying/transform-to-latin1 and returns the
> QByteArray. So it seems that toLocal8Bit() is still making a copy.
> 
> [1] https://github.com/qt/qtbase/blob/5.12/src/corelib/tools/qstring.cpp#L5275
> 
> Cheers,
> 

Thanks a lot for investigating this!
I think in this case it will be more appropriate if you sign the patch.
cheers,
Y.

> -- Slavi
> 
>>
>> But anyway, your solution looks cleaner and safer.
>> I will send another version of the patch.
>> Thanks a lot!
>> Y.
>>
>>
>>> Thanks!
>>>
>>>
>>> --
>>> Slavomir Kaslev
>>>
> 
> 
> 
