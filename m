Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05938C4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D8920657
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvsMjEYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfCKNUh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:20:37 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45434 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfCKNU3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 09:20:29 -0400
Received: by mail-ed1-f67.google.com with SMTP id f19so3969920eds.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 06:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PFiKYr+oicewLsBFjISagzbuFGFxQqn+HRNmgc1YLyg=;
        b=JvsMjEYXOhz7cjfa1HwSv3s9kEoBHBIPUKKyz+LyT29gfYLX2vYYi9UXh31WUiUi0N
         FJlYKyF1N2RulEp2XWeBekFRCWxZD1KdPtGjLZ/mWECyJBi+dkNeKSYnTnNxnzztzFs+
         LmzFObb4OmN7I2Ey7FpCjs09hN/XVfdc/If0+8h/aK6q121r+q0O5iSEho6gbnF2iQJ6
         pNCYqvcOI0uOTOXj76YcX3pjl2X2hNcgLYNqWW2VBMENqh+UV3jDpTltiFEkUcrfhSYm
         J8rdsklQiNEUc6MPIO+u/ctYaNgiPMO+BeXkCzDkQVs0OF61PGfE7y2oA/krAUeOYLL4
         1VPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PFiKYr+oicewLsBFjISagzbuFGFxQqn+HRNmgc1YLyg=;
        b=krRzhJ/P3yvQ2OKRygCQSyItrG6fiAndDb3lZg83zy/5OYRpIJx85yjPAWnPay8DYp
         Lbw2ZCA2t4QlsQaXHbcKylsK6kZvTze+O4e9dUYbD/OYFjBF2AkdlQCXIixWFO6fNXEf
         3nAOGPrcK1Um/TxX7RFy0x6w+vsXU56imACyeIqAYmJU9Z0PAXAfezfW1Wrh/di2WdvN
         p0xYD2RkqUpHEJ1zAoLwsEtzI/jqAPW21fxF4yzLaMikKFnW4byErVZSgoK8A5cABtZX
         A5PUYf76FeD+A7QFzPtcoR7/EyoivHbFQCX90pT05biYNzl1paWK3500X0WCWNXJRKpQ
         oblg==
X-Gm-Message-State: APjAAAXlRD2Z37SymToAPhzVJpOphwMDOG44WiAEYpZKAMH7dT0c/yZ/
        2ToTTuhx76MsM8ZEwwtN3SRQfxY+
X-Google-Smtp-Source: APXvYqxHQO6M7R/uCa5BlJ2NCQ7S9ObQMAZ+pvExQT1QrvoNgCJy2/ubRBUQ7EewcasGgi0sEEmKew==
X-Received: by 2002:a17:906:a12:: with SMTP id w18mr21993684ejf.70.1552310427662;
        Mon, 11 Mar 2019 06:20:27 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x34sm4711606edm.70.2019.03.11.06.20.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 06:20:27 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
 <20190307154316.19194-5-ykaradzhov@vmware.com>
 <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com>
Date:   Mon, 11 Mar 2019 15:20:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.03.19 г. 14:09 ч., Slavomir Kaslev wrote:
> On Thu, Mar 7, 2019 at 5:44 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>>
>> const char *lib = plugin.toStdString().c_str();
>>
>> This line is a bad idea because the returned array may (will) be
>> invalidated when the destructor of std::string is called.
>>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark/src/KsUtils.cpp | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
>> index 34b2e2d..d7b1753 100644
>> --- a/kernel-shark/src/KsUtils.cpp
>> +++ b/kernel-shark/src/KsUtils.cpp
>> @@ -439,7 +439,7 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
>>
>>          auto lamRegUser = [&kshark_ctx](const QString &plugin)
>>          {
>> -               const char *lib = plugin.toStdString().c_str();
>> +               const char *lib = plugin.toLocal8Bit().data();
>>                  kshark_register_plugin(kshark_ctx, lib);
>>          };
>>
>> @@ -474,7 +474,7 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
>>
>>          auto lamUregUser = [&kshark_ctx](const QString &plugin)
>>          {
>> -               const char *lib = plugin.toStdString().c_str();
>> +               const char *lib = plugin.toLocal8Bit().data();
>>                  kshark_unregister_plugin(kshark_ctx, lib);
>>          };
> 
> Doesn't the new version have the same problem with the temporary QByteArray?
> 
> How about saving the data in a local std::string/QByteArray variable?
> 
>                 std::string lib = plugin.toStdString();
>                 kshark_register_plugin(kshark_ctx, lib.c_str());
> 

Hi Slavi,

As far I can understand toStdString() will create a fresh std::string 
and this string will has its own copy of the characters. However, this 
copy gets out-of-scope as soon as we hit the semicolon of the line.

My understanding was that toLocal8Bit().data() makes no copy so the 
array will go out-of-scope only when the QString is destroyed.

But anyway, your solution looks cleaner and safer.
I will send another version of the patch.
Thanks a lot!
Y.


> Thanks!
> 
> 
> --
> Slavomir Kaslev
> 
