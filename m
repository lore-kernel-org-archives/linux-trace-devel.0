Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAC5C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25F7208C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqjlgrf/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408588AbfITJs2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:48:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52880 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405771AbfITJs2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 05:48:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id x2so1726647wmj.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 02:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xTmTwZUqkr9p++tHK+ftGLG+snCjHDmmTdZ03+GqYkw=;
        b=nqjlgrf/Zd2zb0RyENS4fJ0I2v/3NazsrQDa44DVcFjV8C9xHHRJl4rafdw15qZncI
         L6ISQjD88LTSv/fQiQcmNXCzzAtTFMj5sHTXJhWledZ1DxFhHcB1n8oh1EUvCer6PgP5
         NhFuzykZrkUOwibE2OgRNsyVrPfTK+3t61Qs6g92rU/PTySWNt28GUrlAlHnHcWFf8Tq
         q8IieonXoPjOpdk6mkn6IZL/yzbvUG5RRu6NjP6T6HIA3CN0kkMc8pF7JcsDsH6lNtr0
         3gsW65zgnUxmaSuV8BulesldEvLz5g6UWvuAbb22BBqOwKFn+7m7lChJQrnZUPQ+Hu8R
         EsdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xTmTwZUqkr9p++tHK+ftGLG+snCjHDmmTdZ03+GqYkw=;
        b=LFxJdlXCM2oOcGnUJkRJZh/8evhgODG/GE0f8FIUZMupIOAlV3F8PebjyAq9Rf4qpD
         l3h5hLQbScmgelnFWSSNkuqrhJ/aoyvQ9PucXaQ2ht/4tCMqd9HWCb8f7vTuvp0j5Lj5
         ujTWQNwDbxpFjiqfj/AXyS6t3GwG8jafQND+phjow50FpDXvGMG4ANBHDYK2Y1q05lPS
         GT285kUBQz3ySeZokau65LtcVy1wDQIgYiF6zyXaLq19RGCHhrtsZuclsg78cWeA/VF6
         zC/2g0vicA45DtQ3M5Z7PqNvkjMvgtBTzv6u8YzZ6T1uUH3mTdZpzM8UgdjXmNdB4mLc
         iMvQ==
X-Gm-Message-State: APjAAAW4L1mseTigc8dVTyVlJUFQCZsa/pVC9yPYgNb9j5TVq3h8+1QF
        1rowlsnUaKTAs/uqtIyIjRzKmlqL
X-Google-Smtp-Source: APXvYqxdFB2eZBKWCX/iH8SqqwTuvB8W6xEsrAyQDYLqD/bAb7xbKcNaSC4wY2BpQamgKKP/qDa2jg==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr2834733wmd.104.1568972905456;
        Fri, 20 Sep 2019 02:48:25 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h63sm1811471wmf.15.2019.09.20.02.48.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 02:48:24 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] kernel-shark: Provide parsing for quotation marks
 in Record command line
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io
References: <20190918142319.11821-1-y.karadz@gmail.com>
 <20190918142319.11821-2-y.karadz@gmail.com>
 <20190919192022.7b9d8918@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <220cd496-9e30-842a-1714-d3f0d90928f9@gmail.com>
Date:   Fri, 20 Sep 2019 12:48:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919192022.7b9d8918@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.09.19 г. 2:20 ч., Steven Rostedt wrote:
> On Wed, 18 Sep 2019 17:23:17 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> +/**
>> + * Separate the command line arguments inside the string taking into account
>> + * possible shell quoting and new lines.
>> + */
>> +QStringList splitArguments(QString cmd)
>> +{
>> +	QString::SplitBehavior opt = QString::SkipEmptyParts;
>> +	int i, progress = 0, size;
>> +	QStringList argv;
>> +	QChar quote = 0;
>> +
>> +	/* Remove all new lines. */
>> +	cmd.replace("\\\n", " ");
>> +
>> +	size = cmd.count();
>> +	auto lamMid = [&] () {return cmd.mid(progress, i - progress);};
>> +	for (i = 0; i < size; ++i) {
>> +		if (cmd[i] == '\\') {
>> +			cmd.remove(i, 1);
>> +			size --;
>> +			continue;
>> +		}
>> +
>> +		if (cmd[i] == '\'' || cmd[i] == '"') {
>> +			if (quote.isNull()) {
>> +				argv << lamMid().split(" ", opt);
>> +				quote = cmd[i++];
>> +				progress = i;
>> +			} else if (quote == cmd[i]) {
>> +				argv << lamMid();
>> +				quote = 0;
>> +				progress = ++i;
>> +			}
>> +		}
>> +	}
>> +
>> +	argv << cmd.right(size - progress).split(" ", opt);
>> +
>> +	return argv;
>> +}
> 
> I still find the above hard to read, but so be it ;-)
> 
> Anyway, not quite yet. I just noticed that if I do:
> 
>    echo "this \" is \" a \"test"
> 
> The output has:
> 
> ("echo", "this \" is \" a \"test")
> 

Hi Steven,

This is a Qt printing artifact. The printout is trying to show clearly 
that this list contain only 2 strings. That is why it adds those 
backslashes. In the code of the example, try adding this:

                 if (ok) {
                         argList = KsUtils::splitArguments(text);
                         qInfo() << argList;
+                       for (auto a: argList)
+                               cout << a.toStdString() << endl;

                         proc.setProgram(argList.takeFirst());
                         proc.setArguments(argList);


and you will see what I mean.

Thanks a lot for being a tester!!!
Yordan

> 
> We don't want to keep the backslash here. We want to remove it before
> passing it as an argument.
> 
> The above should be:
> 
> ("echo", "this " is " a "test")
> 
> (thinking that you put in the outside quotes. In other words, if I have:
> 
>   echo "hello \"there\""
> 
> We should break that up into:
>    arg0=echo
>    arg1=hello "there"
> 
> -- Steve
> 
