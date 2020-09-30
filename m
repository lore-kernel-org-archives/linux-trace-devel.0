Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95599C4727F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 13:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F771206B2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 13:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uQoPzsG8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgI3Nzw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 09:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgI3Nzt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 09:55:49 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A18CC061755
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 06:55:49 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g4so1923415wrs.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Sep 2020 06:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GRa9pqjFUeG4rtjj5gMI1QU/2wkiAfXSRgAn+A+SEyA=;
        b=uQoPzsG8ZBJI573yWY0E+GFLPj27XueYZUzpH5Xh4Ml3ou2p9ShZbrVMPrzMwdkid8
         9vXUnqvC2fWpBDjrbz5qACjbSMO5TxQ0tbUkNF73DL3id8nNO/2ALwpg56qgoUjF02zG
         TGoBrBMOUf31pttsDAQsTG7pyQ1eX3uRo/iinTk/32jwpJh1MmArXHz5esbyMzSGSc1l
         lAro1sec76686F5YbJ6Q7pZ/KUrJvqPZSIdDBcBH1auSZqElxU5Ie3nERUwLI2C86GPA
         Mpxo7e1Zg0kFeNPlx23QW5EZMKPtCgrdt+6K5tBY/kfQge0Vnu+gB95ywQRNUuiM8Har
         n3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GRa9pqjFUeG4rtjj5gMI1QU/2wkiAfXSRgAn+A+SEyA=;
        b=qBxXjccdG8PZV42Bu380IHchCV5cW8D/rZlFGx82F+b29NDpkFlTnJ6vKJ8hbs4HC6
         ezg+S0e34aUX/hwkSD6NquvaYfvTX51J17CAiAn7Nk80aHfnKluVtbhXQMLAA/pKxl+T
         1TEi30cLhnWczyk2g6dM//o6/tR8GMOV0xp97yO8DZMze0vsStMy2nAGMsUtVvf6Elkv
         xe0f1md0496nsaFh4wTdAaG4b1qRkR48iOktM+fGYGl9gzZOUGQ0CSy9r+dxIs/lJCOA
         7athFCXmFITM7slPI96W3d08o5/J0RvlqSGMPBYS1v4Ym/NlVaNrjLpkcgJPco9+opaQ
         HmKw==
X-Gm-Message-State: AOAM531oZWYiSoYH6yGpkyUqn0XLuUiB42QlIRW1pqikXXdUxxgWX6Xx
        VdMDKav8DjAw36eyBEwMStJESPIDe6A=
X-Google-Smtp-Source: ABdhPJwOvBk0hmob9mNZSAZkS8vYSIDaBVeOFZvR2SVcp4oJiYIMpauXTc67fUTX/ufpNs0nb7SAtw==
X-Received: by 2002:adf:e989:: with SMTP id h9mr3573290wrm.38.1601474147683;
        Wed, 30 Sep 2020 06:55:47 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id f23sm3155305wmc.3.2020.09.30.06.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 06:55:46 -0700 (PDT)
Subject: Re: [PATCH 1/4] kernel-shark :Fix all build warnings for gcc 10.2.1
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200916065007.9755-1-y.karadz@gmail.com>
 <20200929170555.3f45e952@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <bd59b018-df9c-fa0d-5b6a-7de2ba4c30fc@gmail.com>
Date:   Wed, 30 Sep 2020 16:55:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929170555.3f45e952@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.09.20 г. 0:05 ч., Steven Rostedt wrote:
> On Wed, 16 Sep 2020 09:50:04 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> @@ -606,21 +603,17 @@ void KsTraceGraph::_updateGraphLegends()
>>   void KsTraceGraph::_updateTimeLegends()
>>   {
>>   	uint64_t sec, usec, tsMid;
>> -	QString tMin, tMid, tMax;
>>   
>>   	kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
>> -	tMin.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>> -	_labelXMin.setText(tMin);
>> +	_labelXMin.setText(_t2str(sec, usec));
>>   
>>   	tsMid = (_glWindow.model()->histo()->min +
>>   		 _glWindow.model()->histo()->max) / 2;
>>   	kshark_convert_nano(tsMid, &sec, &usec);
>> -	tMid.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>> -	_labelXMid.setText(tMid);
>> +	_labelXMid.setText(_t2str(sec, usec));
>>   
>>   	kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
>> -	tMax.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
>> -	_labelXMax.setText(tMax);
>> +	_labelXMax.setText(_t2str(sec, usec));
>>   }
>>   
>>   /**
>> diff --git a/kernel-shark/src/KsTraceGraph.hpp b/kernel-shark/src/KsTraceGraph.hpp
>> index c53258c..8abc06b 100644
>> --- a/kernel-shark/src/KsTraceGraph.hpp
>> +++ b/kernel-shark/src/KsTraceGraph.hpp
>> @@ -108,6 +108,10 @@ private:
>>   
>>   	void _markerReDraw();
>>   
>> +	QString _t2str(uint64_t sec, uint64_t usec) {
>> +		return QString::number(sec) + "." + QString::number(usec);
> 
> Hmm, if sec is 5 and usec is 1, would the above work? That is, would it
> give:
> 
> 	"5.000001"
> 
> Or would it give:
> 
> 	"5.1"
> 
> which would be wrong.
> 

Yes, this is wrong. Thanks a lot Steven!
Do you prefer to re-send the entire patch-set or only this one?

thanks,
Yordan

> -- Steve
> 
>> +	};
>> +
>>   	enum class GraphActions {
>>   		ZoomIn,
>>   		ZoomOut,
