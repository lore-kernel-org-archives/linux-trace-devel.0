Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0D9C31E40
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 12:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FCF20B7C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 12:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GleFKiI8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406764AbfHIMN7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 08:13:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53489 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfHIMN7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 08:13:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id 10so5489133wmp.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Aug 2019 05:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zEbNkJLy3jLwv3tY3FOMJN3RT/umpAemlOAIpfRnXaw=;
        b=GleFKiI8ItyMIaUfyh0DcJ5XD82Qg4oP+sSDPu5wBpD/wY4K/vfJu/0FvzFu41Aj+X
         3LMD5nvfqW6xzQ6d1NP52CEgTYY2r3hHYwifLXrm8LqZSZC0D/ojP77Wp7u5bIM7/3n4
         BI5J/q+fyGzEiwuLEqe2uXfu5QPMGWvo1nkt3GnbL5cNFib+NqXRHtjMki5uRHXpE6Hq
         hgCWpy+H8BEOTojeVi/p0mihvhzf8e2f1gy20jeYRtvFuymf7LSBp/Cudo2vG/DfoG1A
         UQf86yIasqhwWHRHWpIiR0LjHqtZsfqAFYxg777x27boUja5M3Pub2uk5eZhNikMQE0e
         l5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zEbNkJLy3jLwv3tY3FOMJN3RT/umpAemlOAIpfRnXaw=;
        b=EKs7DX5aX0xp4rLpPVeZ0ylAq4HM81eMbEU8PIk0+X6hGJn0AwWTvFtQrSnGqCVmRE
         +2XxGm0G0H36RbMjnvoVB86KtfcovAseBVA0sXb8Y3eI82VYNJEd1P9WzhSDhmTgdKgQ
         ruWjqwiqDTZUpiLMhV/hamO029tEY0bF+ZJ8pdPSrMkTpXTOlpj/qgClzGDX7PYe6Pfr
         1dg42RqDZe2Ob2nxK9fi5ydQSzhztMrh4TG7YKz77T63qRZEofnZUZZRtrw7AqMRuZSU
         86/MvTJcqdwxWj5iD4X+SCX2+Wkx8gJzoBFaPVwI0qTB0mZEazDWapZkyuj1Bz/SyYDc
         52ow==
X-Gm-Message-State: APjAAAUlrjFFSMDl+9BOnB1FhAW8BPEzKS19ni9/Ta7qVMYYJAd6vgZ9
        ts/9TEOPjzB1vMkvmwCzqS8=
X-Google-Smtp-Source: APXvYqwtOufuaGucKVXm3bKGb1af4v32bA4A5OI1Zg3yqvMOTCAnocYYV1ps2MrcCX5t3+tZxDS7pw==
X-Received: by 2002:a7b:c852:: with SMTP id c18mr3795929wml.44.1565352837216;
        Fri, 09 Aug 2019 05:13:57 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q20sm26595406wrc.79.2019.08.09.05.13.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 05:13:56 -0700 (PDT)
Subject: Re: [PATCH 1/3] kernel-shark: Show warning message when running as
 Root
To:     Mike Auty <mike.auty@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
 <20190809080623.7548-2-y.karadz@gmail.com>
 <430194dd-0e96-bb3a-a2de-e4379dd540a1@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Message-ID: <a4870c9e-2a1b-c8b8-d334-8c77851e5026@gmail.com>
Date:   Fri, 9 Aug 2019 15:13:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <430194dd-0e96-bb3a-a2de-e4379dd540a1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hey Mike,
Very well spotted, thanks!

It will be great if you can test the patches on your machine.

cheers,
Yordan

On 9.08.19 г. 13:33 ч., Mike Auty wrote:
> Hiya,
> 
> I can't really review the rest of the code, my main language is python,
> but I spotted a couple of minor typos that might be worth fixing?  I
> didn't want to post them to everyone since they're fairly trivial.  5:S
> 
> "noRootWorn" might want to "noRootWarn"
> "your one risk." might want to be "your own risk."
> 
> Thanks for putting the patches together so quickly!  5:)
> 
> Mike  5:)
> 
> On 09/08/2019 09:06, Yordan Karadzhov (VMware) wrote:
>> Running the KernelShark GUI with Root privileges is not recommended due
>> to security reasons. The user will be allowed to continue on its own risk.
>>
>> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204475
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark/src/KsMainWindow.cpp | 28 ++++++++++++++++++++++++++++
>>   kernel-shark/src/KsMainWindow.hpp |  2 ++
>>   2 files changed, 30 insertions(+)
>>
>> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
>> index 6439265..2560bf8 100644
>> --- a/kernel-shark/src/KsMainWindow.cpp
>> +++ b/kernel-shark/src/KsMainWindow.cpp
>> @@ -76,6 +76,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>>   	_createMenus();
>>   	_initCapture();
>>   
>> +	if (geteuid() == 0)
>> +		_rootWarning();
>> +
>>   	_splitter.addWidget(&_graph);
>>   	_splitter.addWidget(&_view);
>>   	setCentralWidget(&_splitter);
>> @@ -1271,3 +1274,28 @@ void KsMainWindow::_deselectB()
>>   	_mState.updateLabels();
>>   	_graph.glPtr()->model()->update();
>>   }
>> +
>> +void KsMainWindow::_rootWarning()
>> +{
>> +	QString cbFlag("noRootWorn");
>> +
>> +	if (_settings.value(cbFlag).toBool())
>> +		return;
>> +
>> +	QMessageBox warn;
>> +	warn.setText("KernelShark will have Root privileges.");
>> +	warn.setInformativeText("Continue on your one risk.");
>> +	warn.setIcon(QMessageBox::Warning);
>> +	warn.setStandardButtons(QMessageBox::Close);
>> +
>> +	QCheckBox cb("Don't show this message again.");
>> +
>> +	auto lamCbChec = [&] (int state) {
>> +		if (state)
>> +			_settings.setValue(cbFlag, true);
>> +	};
>> +
>> +	connect(&cb, &QCheckBox::stateChanged, lamCbChec);
>> +	warn.setCheckBox(&cb);
>> +	warn.exec();
>> +}
>> diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
>> index 62e66a0..4a7b8ab 100644
>> --- a/kernel-shark/src/KsMainWindow.hpp
>> +++ b/kernel-shark/src/KsMainWindow.hpp
>> @@ -238,6 +238,8 @@ private:
>>   
>>   	void _deselectB();
>>   
>> +	void _rootWarning();
>> +
>>   	void _updateFilterMenu();
>>   
>>   	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
>>
> 
