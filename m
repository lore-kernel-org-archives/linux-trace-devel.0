Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7CDC432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 11:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5F321781
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 11:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVM7vSaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfK1L3I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:29:08 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38247 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfK1L3I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 06:29:08 -0500
Received: by mail-lj1-f194.google.com with SMTP id k8so17570485ljh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 03:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Onc4vO8W/FGDY+252G6VDJOlY2/l9eEqT+YULvZfNR0=;
        b=PVM7vSaCsXGdPhSG9TNp1u5J1kkQjShYQet1zBdCK5mmRRLSVe8tkMCsYPoJXp3aRM
         QRFxz/8W3Oe4SXUV2cIYpg+0W0kp5YxYMzR1Iy3msbdBfCAOoyzPAeBBvK8gaSR7BvUl
         u1t8NQFgdNxB6frOOdEOoN85LI9lEgIhSBHjx+tYthmnS8FpLJAMM+WFRaVRZG6KHvJh
         wEZwQGty2Lzf+C0K0Wj80A610s5bxL9rceY7O2ctvnxdlT4EFdv3aJSZzp1CWxb2nMsE
         5X3OZhbrzguZq8ylQtBD6bB/neCyin7ZA0g0F/kb8OZFOdbRIMHOgtTWWJ/IwkZ/OTV8
         MEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Onc4vO8W/FGDY+252G6VDJOlY2/l9eEqT+YULvZfNR0=;
        b=KU3BqfSXibCncdc7OavTK7gCLYCDS6NfQBjCNqmVFBzsMOTjH8nuU/ks9a/Ud+WzuX
         yH9A/Hb+vZ1GLlKE45YRe5J8YXA9U03u2t30J6BkrJmLnJkvRuhTrrBr8df9mivWY+s/
         wwKKdOMqYfdQWNZ5NffqmBtQ7avuh6eGBvXbXRrLUyh1JXVIaM0eJZxXOn2ksf3MEPv7
         bewqb1+kTy5ucGXu231oumoSOsK+MjKkjDgHkZ7gW+LoKw0py02GPFDdSB4sVbRYlWim
         0SjuVQxr5lwJuHBAynVlqMqbV0aIdKX9ayAUh2u0dpqAmL/iElOf+/wWxmXze9dy29+M
         W4Fg==
X-Gm-Message-State: APjAAAX+2AP0iCTChR332cPlOMALf33/VOqm5SqYTPQYKy9cv11TS0rM
        c3REUywzV/f/C3/y5WblyB8dsjRR
X-Google-Smtp-Source: APXvYqyu6QgTRpjfTcwFtImQdAuSNguI/1laYRSXTnpLfEVzQZvwL/EAha4CMZsNK30HlHusneYX2g==
X-Received: by 2002:a2e:9e97:: with SMTP id f23mr34189332ljk.89.1574940544916;
        Thu, 28 Nov 2019 03:29:04 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s76sm3153836lje.53.2019.11.28.03.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2019 03:29:04 -0800 (PST)
Subject: Re: [PATCH v2 3/3] kernel-shark: When running as Root save all config
 settings in /root/
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20191023122145.14314-1-y.karadz@gmail.com>
 <20191023122145.14314-3-y.karadz@gmail.com>
 <20191127151310.680478f1@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <7e2a221d-d1f0-ec91-ae42-6a9d48440fc5@gmail.com>
Date:   Thu, 28 Nov 2019 13:29:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191127151310.680478f1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 27.11.19 г. 22:13 ч., Steven Rostedt wrote:
> On Wed, 23 Oct 2019 15:21:45 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> If KernelShark is running with Root privileges, do not save the settings
>> in the standard location. Otherwise the configuration files will be owned
>> by Root and later the normal user will have no access to those files.
>>
>> The patch seems to do the right thing in all cases that I tested, however
>> there is definitely something that I do not understand. QDir::homePath()
>> always returns the path to the home of the normal user, even if I build
>> and run kernelshark as root (sudo -s).
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark/src/KsMainWindow.cpp | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
>> index 3402764..bd6c338 100644
>> --- a/kernel-shark/src/KsMainWindow.cpp
>> +++ b/kernel-shark/src/KsMainWindow.cpp
>> @@ -69,7 +69,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>>     _contentsAction("Contents", this),
>>     _bugReportAction("Report a bug", this),
>>     _deselectShortcut(this),
>> -  _settings("kernelshark.org", "Kernel Shark") // organization , application
>> +  _settings(_getCacheDir() + "/setting.ini", QSettings::IniFormat)
>>   {
>>   	setWindowTitle("Kernel Shark");
>>   	_createActions();
>> @@ -431,6 +431,9 @@ QString KsMainWindow::_getCacheDir()
>>   		dir = QStandardPaths::writableLocation(appCachePath);
>>   		dir += "/kernelshark";
>>   
>> +		if (geteuid() == 0)
>> +			dir.replace(QDir::homePath(), "/root");
>> +
>>   		if (!QDir(dir).exists())
>>   			lamMakePath(false);
>>   	}
> 
> I'll pull this patch in, but this assumes that root is always at /root.
> I've had machines where that was not the case. I wonder if we should
> add something like this on top of this patch. Not this change directly,
> (because this is me just writing C with at C++ compiler ;-), but
> something that is more the Qt way...
> 
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index bd6c338f..56cf9b9b 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -31,6 +31,43 @@
>   #include "KsCaptureDialog.hpp"
>   #include "KsAdvFilteringDialog.hpp"
>   
> +static QString find_root_home(void)
> +{
> +	FILE *fp = fopen("/etc/passwd", "r");
> +	char *buf;
> +	char *sav;
> +	char *id;
> +	size_t n;
> +
> +	if (!fp)
> +		return QString("/root");
> +
> +	n = 0;
> +	while (getline(&buf, &n, fp) != -1) {
> +		/* user */
> +		strtok_r(buf, ":", &sav);
> +		/* type */
> +		strtok_r(NULL, ":", &sav);
> +		/* pid */
> +		id = strtok_r(NULL, ":", &sav);
> +		if (atoi(id) != 0) {
> +			n = 0;
> +			free(buf);
> +			continue;
> +		}
> +		/* gid */
> +		strtok_r(NULL, ":", &sav);
> +		/* group */
> +		strtok_r(NULL, ":", &sav);
> +		/* home */
> +		QString ret = QString(strtok_r(NULL, ":", &sav));
> +		free(buf);
> +		return ret;
> +	}
> +	free(buf);
> +	return QString("/root");
> +}
> +
>   /** Create KernelShark Main window. */
>   KsMainWindow::KsMainWindow(QWidget *parent)
>   : QMainWindow(parent),
> @@ -432,7 +469,8 @@ QString KsMainWindow::_getCacheDir()
>   		dir += "/kernelshark";
>   
>   		if (geteuid() == 0)
> -			dir.replace(QDir::homePath(), "/root");
> +			dir.replace(QDir::homePath(),
> +				    find_root_home().toStdString().c_str());
>   
>   		if (!QDir(dir).exists())
>   			lamMakePath(false);
> 
> This reads the /etc/passwd file and searches for the pid of 0, and
> returns the home path for that user. On any error it just
> quietly defaults back to "/root".
> 

Hi Steven,

Very good point. Thanks a lot!

I am sending a Qt-ish looking patch ;)

cheers,
Yordan


> -- Steve
> 
