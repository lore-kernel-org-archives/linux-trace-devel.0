Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D56FC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 06:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1504621872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 06:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeukmS6u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfCOGNP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 02:13:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34710 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfCOGNP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 02:13:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id o10so8394731wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 23:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YavLlIAjck0ylvW7tVcKd0CCin1kBj8f1/1JkrkcHA0=;
        b=ZeukmS6u8x/AWzi1KSGbN+x32zO8SHhJs0y/VNYXpqxuMmyNeNpr/sUG1ndSK5DBQt
         63elVkiX1kMfKRNYRQHNwS2sSTIS70HP05VSZAxm3Ij3Exzb99vKILsk3H4JqoEBJVP1
         DYa94SmvGZAJkvSs/K6l6U0E7KwOqgc18TV9iyNSd4Q7U+PqYgklE8o6U8mQBFrgi4Pi
         vRdAbDZJCwFlR9JLhe/tjHMKXUVVvpTKmqxw6T4HuEZMBnRULzBPuku0Y+mk/s3qBkEv
         MNEgLnGmlXjScm3qt/Z1bnpoJ4xHg2XVdTvNvnPNMCeDsvIPyc5ok3iJtCa5AIEKcUsG
         lzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YavLlIAjck0ylvW7tVcKd0CCin1kBj8f1/1JkrkcHA0=;
        b=QzIZ/IHoRsLYc7FzpGFUv2LRg4xklsJEwZPHola2TVc4ZO4tdtlXgICr6O8y7GdBLW
         kpYgxD7ThEQzBbINiT+fEYUvo5ry1gCSGATDxALQzIBsVfygEzH9SLgHMbuXe8OQYxUo
         Mi6iXKQYaZu2BzbWB7ks5Uy0gaLgJhIf6hAXTPTmnDJYRMjb9/d2w7apO1wYBVLz4Lo/
         qKKSUcmAltOeHnOSGA1IxmEH1Eko8gNQkt+zT/YFGR+bRwJkITGJ5A+DV8CP8yrPl1A+
         RXbuHqiVSwcqIz4U/W0Eo0NYHvq//MZ2r6nXglpPAdCeMZnUaV5Y7plolUPQEYktS4aR
         TMwA==
X-Gm-Message-State: APjAAAVY46wMQZIBn0DI2alslXwoTecqF5c2qYc0RCh5cxkvdNa+/9jf
        2UVEDMIkfy9HHDlQUpb2TJHdAt+z
X-Google-Smtp-Source: APXvYqx8DMATWQTeyUUjI5xb9a5T1YDU4Pj1gQTbKmlruaWXrJDP/Eg5ZuuXp/794zQ+gj46VIvQ3g==
X-Received: by 2002:a1c:cecd:: with SMTP id e196mr856045wmg.31.1552630393105;
        Thu, 14 Mar 2019 23:13:13 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b4sm1195944wmj.3.2019.03.14.23.13.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 23:13:12 -0700 (PDT)
Subject: Re: [PATCH 06/12] kernel-shark: Load Last Session from command line
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190314151012.905-1-ykaradzhov@vmware.com>
 <20190314151012.905-7-ykaradzhov@vmware.com>
 <20190314194711.62436074@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <094b949a-f2ba-95ea-7e76-1612e286a9a3@gmail.com>
Date:   Fri, 15 Mar 2019 08:13:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190314194711.62436074@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 15.03.19 г. 1:47 ч., Steven Rostedt wrote:
> On Thu, 14 Mar 2019 17:10:06 +0200
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> ./kernelshark -l  will load directly the Last Session
>>
>> Signed-off-by : Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark/src/kernelshark.cpp | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel-shark/src/kernelshark.cpp b/kernel-shark/src/kernelshark.cpp
>> index 2ec91de..1ec6678 100644
>> --- a/kernel-shark/src/kernelshark.cpp
>> +++ b/kernel-shark/src/kernelshark.cpp
>> @@ -28,6 +28,7 @@ void usage(const char *prog)
>>   	printf("  -p	register plugin, use plugin name, absolute or relative path\n");
>>   	printf("  -u	unregister plugin, use plugin name or absolute path\n");
>>   	printf("  -s	import a session\n");
>> +	printf("  -l	import the last session\n");
>>   }
>>   
>>   int main(int argc, char **argv)
>> @@ -40,7 +41,7 @@ int main(int argc, char **argv)
>>   	int c;
>>   	bool fromSession = false;
>>   
>> -	while ((c = getopt(argc, argv, "hvi:p:u:s:")) != -1) {
>> +	while ((c = getopt(argc, argv, "hvi:p:u:s:l")) != -1) {
>>   		switch(c) {
>>   		case 'h':
>>   			usage(argv[0]);
>> @@ -65,6 +66,12 @@ int main(int argc, char **argv)
>>   		case 's':
>>   			ks.loadSession(QString(optarg));
>>   			fromSession = true;
>> +			break;
>> +
>> +		case 'l':
>> +			ks.loadSession(ks.lastSessionFile());
>> +			fromSession = true;
>> +			break;
> 
> This produces:
> 
> [ 69%] Building CXX object src/CMakeFiles/kernelshark.dir/kernelshark.cpp.o
> /work/git/trace-cmd.git/kernel-shark/src/kernelshark.cpp: In function ‘int main(int, char**)’:
> /work/git/trace-cmd.git/kernel-shark/src/kernelshark.cpp:72:22: error: ‘class KsMainWindow’ has no member named ‘lastSessionFile’; did you mean ‘loadSession’?
>      ks.loadSession(ks.lastSessionFile());
>                        ^~~~~~~~~~~~~~~
>                        loadSession
> 
> 
> Am I missing something?
> 

Looks like you are missing the two previous patch sets:

[PATCH v2 0/3]  Tuning the KernelShark build system
and
[PATCH v2 0/4] Add dialog for loading user-defined plugins

Thanks!
Yordan



> -- Steve
> 
>>   
>>   		default:
>>   			break;
> 
