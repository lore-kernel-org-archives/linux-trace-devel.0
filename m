Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA38C4CECD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 10:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825AB21881
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 10:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUZYtj/u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfIQKo5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 06:44:57 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:39126 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfIQKo4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 06:44:56 -0400
Received: by mail-wr1-f49.google.com with SMTP id r3so2603191wrj.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 03:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1eTBsLhwuXQRKVrzrbGA32thwboSzmKqgC0tUVVspAg=;
        b=GUZYtj/u1B+CbBBlE8aH1SrzEkXnwsSfrNI3D33MLlcQWRy8cJ/JRV2+HEjlmxACHf
         /+p77+Bw7xaGU/RHiXf0gtKez54pfADeWNJTCz0ms8y9bsIO4BQaf8eTL388swNiqtFR
         R++1v9CbRWmvN07hIhEMrVOqhAqyWsIpJpngGliNW0jiNltQqNV/R/ZY10gz1Jf8UE1Q
         +/NTliNSixUnSADNnsvLcnnFGod8t8UY5uE4V/o2of3/xmMUO3ZaaesGwnCXVkYWiJ7+
         mTs9a5YiDEuU6T0Jz0/6i9aw8gLb4truTk/cGAAQfvj+OsWpIZ6OWb7TSMN3n2q4NOi4
         thNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1eTBsLhwuXQRKVrzrbGA32thwboSzmKqgC0tUVVspAg=;
        b=ewhblt+U8ulSS5BKrcP/a1V8Huqu8NTtaa7lwFCWqfHpBavkvtUPirxEVzoR8fOEAm
         gwKHjTdDs+ES7rtl3c6/YpAxfQVVlx6hC8Vk1AZOZ5caNuaqdiPNdBaszHRnO5YlEuu1
         s6g97G+mZ+C7oFfAOJySsWYXeSvk1QUH6Tq9emc1zXlzZCe+5BNT+O8DAQrT+ad9ND1G
         5yNivalVs8GT3pMZuJySp7UVLmM+C9sRiUhGyl2g31PxQ6O/GFodRfWQ/gS6BuXsHzB4
         h98CyAEVHe4UjL4gXwLT4xeaDkuzSNUO68d6qvvcWkA1oEVF+eEDS8DIw13PtG7RA3Nb
         cERg==
X-Gm-Message-State: APjAAAWpIFk1krVIS4vzHgCl+OhB4eAn9OnpXpjDaeuN57y/JbxmRXpu
        /Xu9GsM/c8haIyIi3jQkSqRpmxoX
X-Google-Smtp-Source: APXvYqz3homhlGRUgrvmsAXupwqUi7go2XPqybpdrTt4HNHOGnT9Wc7ayK7UWGB7Ww7JC+3MP77ATg==
X-Received: by 2002:a5d:4a8a:: with SMTP id o10mr2493860wrq.201.1568717094363;
        Tue, 17 Sep 2019 03:44:54 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm2185955wrm.52.2019.09.17.03.44.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 03:44:53 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stephen Brennan <stephen@brennan.io>
References: <20190827131418.18713-1-y.karadz@gmail.com>
 <20190828092533.493ce25c@gandalf.local.home>
 <20190828093007.0b0bdabb@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <41a6b643-ce85-967e-a47f-99c32f1e2d6a@gmail.com>
Date:   Tue, 17 Sep 2019 13:44:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828093007.0b0bdabb@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 28.08.19 г. 14:30 ч., Steven Rostedt wrote:
> On Wed, 28 Aug 2019 09:25:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Tue, 27 Aug 2019 16:14:18 +0300
>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>
>>> +	cmdTmp = _commandLineEdit.text();
>>> +	if (!cmdTmp.contains('\'') && !cmdTmp.contains('\"')) {
>>> +		/* Split all command line arguments. */
>>> +		argv << cmdTmp.split(" ", opt);
>>> +	} else {
>>> +		int iOpenQuots, iCloseQuots, size = cmdTmp.size();
>>> +		int iSingleQuots = (cmdTmp.count('\'') == 2) ? cmdTmp.indexOf('\'') : size;
>>> +		int iDoubleQuots = (cmdTmp.count('\"') == 2) ? cmdTmp.indexOf('\"') : size;
>>> +
>>> +		if (iSingleQuots < iDoubleQuots) {
>>> +			iOpenQuots = iSingleQuots;
>>> +			iCloseQuots = cmdTmp.lastIndexOf('\'') + 1;
>>> +		} else if (iDoubleQuots < iSingleQuots) {
>>> +			iOpenQuots = iDoubleQuots;
>>> +			iCloseQuots = cmdTmp.lastIndexOf('\"') + 1;
>>> +		} else {
>>> +			emit print("\nERROR: Unable to parse the command.");
>>> +			return {};
>>> +		}
>>> +
>>> +		/* Split the arguments. */
>>> +		argv << cmdTmp.left(iOpenQuots).split(" ", opt);
>>> +
>>> +		/* Everything in between the quotation marks goes in one piece. */
>>> +		argv << cmdTmp.mid(iOpenQuots, iCloseQuots - iOpenQuots);
>>> +
>>> +		/* Split the rest of the arguments. */
>>> +		argv << cmdTmp.right(size - iCloseQuots).split(" ", opt);
>>> +	}
>>
>> This is where I hate C++, because it makes simple things so
>> complicated ;-)
>>
>> What we need to do is simply:
>>
>> 	char *str = _commandLineEdit.text();
>> 	char *last_word = str;
>> 	char quote = 0;
>> 	int i;
>>
>> 	// remove front and end spaces
>> 	while (isspace(*str))
>> 		str++;
>> 	i = strlen(str);
>> 	while (i > 0 && isspace(str[i-1])
>> 		i--;
>> 	str[i] = 0;
> 
> Oops, need to have:
> 
> 	last_word = &str[i];
> 
> here.
> 
> -- Steve
> 
>>
>> 	for (i = 0; str[i]; i++) {
>> 		if (isspace(str[i]) && !quote) {
>> 			str[i++] = 0;
>> 			argv << last_word;
>> 			while (isspace(str[i]))
>> 				i++;
>> 			last_word = &str[i];
>> 		}
>> 		switch(str[i]) {
>> 		case '\\':
>> 			i++;
>> 			break;
>> 		case '\'':
>> 		case '"':
>> 			if (!quote)
>> 				quote = str[i];
>> 			else if (quote == str[i])
>> 				quote = 0;
>> 			break;
>> 		}
>> 	}
>> 	argv << last_word;
>>
>> Note, the above may be buggy, I didn't test it.
>>

Hi Steve,

I understand very well your feelings ;)
However, I also really dislike eclectic programming stiles. Since this 
is part of the C++/Qt code, I would prefer to stick to the C++/Qt way of 
doing things.

Here is a version of your code that is more C++/Qt-ish:


	QString::SplitBehavior opt = QString::SkipEmptyParts;
	QChar quote = 0;
	int i, progress = 0, size;

	cmd.remove(QChar('\\'));
	size = cmd.count();
	auto lamMid = [&] () {return cmd.mid(progress, i - progress);};
	for (i = 0; i < size; ++i) {
		if (cmd[i] == '\'' || cmd[i] == '"') {
			if (quote.isNull()) {
				args << lamMid().split(" ", opt);
				quote = cmd[i++];
				progress = i;
			} else if (quote == cmd[i]) {
				args << lamMid();
				quote = 0;
				progress = ++i;
			}
		}
	}

	args << cmd.right(size - progress).split(" ", opt);

If you are OK with this I will send a new version of the patch.

Thanks!
Yordan



>> -- Steve
> 
