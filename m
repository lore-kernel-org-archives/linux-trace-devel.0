Return-Path: <SRS0=f3YT=YQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28921CA9EB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 10:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE757214B2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 10:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qGgkXKVY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404467AbfJWKtO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 06:49:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40286 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404463AbfJWKtO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 06:49:14 -0400
Received: by mail-lj1-f194.google.com with SMTP id u22so2558191lji.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Oct 2019 03:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U8ch3yFmSxc9y9EUY7mFLORMVmdjWPTeoKK11/C1fNk=;
        b=qGgkXKVY6IszxjflLgwHx3M1j0Hi9+NqtuYz43Al31BEQkMiWqp0/ooPVl7tkeJIm0
         i0n7xN4VxnbkDKlUJF7X/RvIwbj8Gn7PQuw/FTj4x6pCrDLodtb1ccDKuEt7oInzt3qm
         /ArhZJIGvZAdJvo/vZK0GPfE5AfSoqLmKTn+TS2RbJA1/7VsMnlCywvaQhdXIKI/HErU
         R52MJjpE9Q1o0cjUISRJhat9yZ5COBsP1lhE+i8rrLooT2dvp7PTRaPvmoB3qFg8oOmX
         xiH9IOnkuyRD2J3vBQf1k4kwpwUA70uCFiOT+d6CNH+ALNK9LvFrP3yO5OWrJRjusLtj
         0lKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U8ch3yFmSxc9y9EUY7mFLORMVmdjWPTeoKK11/C1fNk=;
        b=pmEZnLUSdi+NA7UhMvcM4NddT4xZAu4B0yAKUyNZRRQyKkW/jzDfMsXa2zCaZlMwIA
         tziWtCcxFtT/S6JX3HmWCB011Nqnz3U6kStTTS7+VjKHteUQrWZq4QTQKmICfFk/76ET
         NnEnJc7qUoKdYEHsWBGrUYJj/G5ngnHt3/VCS0JLMN9qVwgNfC/ObE24eTobZUpGpazQ
         CAmlYRuodxI5C+V4tJKFQSZVeyvlMkhWpOXQHnAaIZ5dk5GB34HfCr/+jlL6LOQepH5/
         sMlf+33nmv3YUrBqYlfHMGjDCgAs2rP++Z0YvyqDDq/sPlaZBqskYLV/KAeTDiJHrArJ
         nKzg==
X-Gm-Message-State: APjAAAXtiSVYGdZf6j/mXwiPaeWK4RcVUytmylCQ2ud4NNgloz61ki3i
        p+woVIFJDeb98BzeM/ghs1Nxo/mo
X-Google-Smtp-Source: APXvYqy6c+s97HVjsvdmmAf8p7+cuyLhjs4468JTLq5xJeK6JWGnBhWv6VCXy58Q0uo3gBADncUZ0w==
X-Received: by 2002:a2e:878a:: with SMTP id n10mr22450425lji.229.1571827752112;
        Wed, 23 Oct 2019 03:49:12 -0700 (PDT)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q27sm5825257lfn.96.2019.10.23.03.49.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 03:49:11 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark: Do not save the settings when running
 as Root
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20191018074722.6976-1-y.karadz@gmail.com>
 <20191018074722.6976-2-y.karadz@gmail.com>
 <20191018103238.3b3877cb@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <05ece807-fb3f-fda5-e1f7-e04a63a1d0aa@gmail.com>
Date:   Wed, 23 Oct 2019 13:49:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018103238.3b3877cb@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 18.10.19 г. 17:32 ч., Steven Rostedt wrote:
> On Fri, 18 Oct 2019 10:47:21 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Do not save the settings if KernelShark is running with Root privileges.
>> Otherwise the configuration file will be owned by Root and later the
>> normal user will have no access to it.
> 
> Perhaps we should have the settings saved in the root home directory?
> 
> Reason being, I run kernelshark as root all the time (on my test boxes,
> where I only log in as root).
> 
> And I would still like to have the settings saved. Maybe check if the
> settings path is the same as $HOME variable?
> 

OK I think I have a solution that does a better job. Do you prefer to 
resend all 3 patches or just this one?

Thanks!
Yordan


> -- Steve
> 
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark/src/KsMainWindow.cpp | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
>> index 3402764..6da8670 100644
>> --- a/kernel-shark/src/KsMainWindow.cpp
>> +++ b/kernel-shark/src/KsMainWindow.cpp
>> @@ -152,9 +152,15 @@ KsMainWindow::~KsMainWindow()
>>   					_session.getConfDocPtr());
>>   	}
>>   
>> -	_settings.setValue("dataPath", _lastDataFilePath);
>> -	_settings.setValue("confPath", _lastConfFilePath);
>> -	_settings.setValue("pluginPath", _lastPluginFilePath);
>> +	/*
>> +	 * Do not save the settings if KernelShark is running with Root
>> +	 * privileges. Otherwise the configuration file will be owned by Root.
>> +	 */
>> +	if (geteuid() != 0) {
>> +		_settings.setValue("dataPath", _lastDataFilePath);
>> +		_settings.setValue("confPath", _lastConfFilePath);
>> +		_settings.setValue("pluginPath", _lastPluginFilePath);
>> +	}
>>   
>>   	_data.clear();
>>   
> 
