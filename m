Return-Path: <SRS0=eYsA=6L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAF2C54FCB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 14:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7256206D9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Apr 2020 14:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NuMmfMRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgD0Ooy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgD0Oox (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 10:44:53 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A35C0610D5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 07:44:53 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id w20so17891421ljj.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Apr 2020 07:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZCW3hh4+PQLLmOaOE8FmlyvIcDdZTuS+l+tu5MM+5M=;
        b=NuMmfMRYkUFfnCYnaenPeVufs6ZkILHvUB3DJsbWeZbLQND+DjqldIWrv/7OYCS2AD
         Lyov73N1XMjSNeOXh0ocMvekobzPVv2D4cwBuALQ5R/FM+b3cUBgokdLUQw2hYAeea+R
         ozf43hjWQDfkW2HABvNpuXUhy0dvemrzBPdN1GegfQtZFwYJ9lTWyMSDKkciXFqouZk0
         06j6Ide91rcWehhu73XmTppMN9oQMSFhM0bheS6X33J03KNLqDHkxToDIsCqeuAnehYe
         84SMpzrpP2aJcTPWeYm5b/sljq2pYoCkA/VtKvNR7L2FBWg9XtyelRczj36NdGFyrVyf
         6zIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZCW3hh4+PQLLmOaOE8FmlyvIcDdZTuS+l+tu5MM+5M=;
        b=ZASBfIprMQpOhicImtc20QsXdiFKwi68L25oVRUGA7FvKS0Tq0o+nq2/+SXRW7WtHw
         GXftOZ0bjW1VXYaGtNAaomik0+vrJDmfqSbuk5Y9z3UYybez3CuwCaMyadHnyf4l2GZr
         dkYMHxVAn7IordPWkmSRk0U3RZvxcSMjDvSlDQ7/Sh1zjFEZgTnVfhl8wdUhSoJpMcYd
         yxZR0/ekUZlrtgalJYH4h579j+OZNuPjfh0UR2iPy1BK1I2MdYdISblV0ap2KjPDCMS9
         L6FT0jD//Uil09NdbOBJW51jKP8tQO/WeklDPqQPKIL95ppPR/LgrxvQmJ/incBvCSRg
         eYlQ==
X-Gm-Message-State: AGi0PualdH1wX55uX6k66iZlMg6gZGE7tBTyrDk+YjhSCEObm7y2gkC2
        +9xQTHUs527PE7OhlAfeYq9SEYscjVw=
X-Google-Smtp-Source: APiQypIxSi4+IC1L0KlPFykynvNM67ldhZh7m0THKma/wFzxAbRlcil6YwL28cAAKa2f2qOgB5LRFQ==
X-Received: by 2002:a2e:b5d2:: with SMTP id g18mr14589817ljn.51.1587998691755;
        Mon, 27 Apr 2020 07:44:51 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id y25sm11468580lfy.59.2020.04.27.07.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 07:44:51 -0700 (PDT)
Subject: Re: [PATCH 2/3] kernel-shark: Change the mechanism of the
 multi-threaded search
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20200330161723.29816-1-y.karadz@gmail.com>
 <20200330161723.29816-3-y.karadz@gmail.com>
 <20200424161246.4d9f22b8@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <69e2a749-8582-35dc-0a6d-5d08988d4a5c@gmail.com>
Date:   Mon, 27 Apr 2020 17:44:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424161246.4d9f22b8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.04.20 г. 23:12 ч., Steven Rostedt wrote:
> 
> After applying this patch, I was hitting a lockup with this file:
> 
> http://rostedt.org/private/trace-all.dat.xz
> 
> By selecting "Event" and searching for "sched" it would hang at %87
> 

Hi Steven,
Very well spotted. I am not able to reproduce the bug directly, but I 
guess this is because you are running this on a machine that has 24 CPU 
cores (or 12 and hyper-trading enabled).

> I found the bug below.
> 
> On Mon, 30 Mar 2020 19:17:22 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> --- a/kernel-shark/src/KsModels.cpp
>> +++ b/kernel-shark/src/KsModels.cpp
>> @@ -52,22 +52,25 @@ size_t KsFilterProxyModel::_search(int column,
>>   				   const QString &searchText,
>>   				   search_condition_func cond,
>>   				   QList<int> *matchList,
>> +				   int step,
>>   				   int first, int last,
>>   				   QProgressBar *pb,
>>   				   QLabel *l,
>> +				   int *lastRowSearched,
>>   				   bool notify)
>>   {
>>   	int index, row, nRows(last - first + 1);
>> -	int pbCount(1);
>> +	int milestone(1), pbCount(1);
>>   	QString item;
>>   
>>   	if (nRows > KS_PROGRESS_BAR_MAX)
>> -		pbCount = nRows / (KS_PROGRESS_BAR_MAX - _searchProgress);
>> +		milestone = pbCount = nRows / (KS_PROGRESS_BAR_MAX - step -
>> +					       _searchProgress);

The problem will show up if this division has no remainder.

>>   	else
>>   		_searchProgress = KS_PROGRESS_BAR_MAX - nRows;
>>   
>>   	/* Loop over the items of the proxy model. */
>> -	for (index = first; index <= last; ++index) {
>> +	for (index = first; index <= last; index += step) {
>>   		/*
>>   		 * Use the index of the proxy model to retrieve the value
>>   		 * of the row number in the base model.
>> @@ -78,17 +81,23 @@ size_t KsFilterProxyModel::_search(int column,
>>   			matchList->append(row);
>>   
>>   		if (_searchStop) {
>> -			if (notify) {
>> -				_searchProgress = KS_PROGRESS_BAR_MAX;
>> +			if (lastRowSearched)
>> +				*lastRowSearched = index;
>> +
>> +			if (notify)
>>   				_pbCond.notify_one();
>> -			}
>>   
>>   			break;
>>   		}
>>   
>>   		/* Deal with the Progress bar of the seatch. */
>> -		if ((index - first) % pbCount == 0) {
>> +		if ((index - first) > milestone) {
> 
> Changing the above to:
> 
> 		if ((index - first) >= milestone) {
> 
> fixes it.

Correct.

> 
>> +			milestone += pbCount;
>>   			if (notify) {
>> +				/*
>> +				 * This is a multi-threaded search. Notify
>> +				 * the main thread to update the progress bar.
>> +				 */
>>   				std::lock_guard<std::mutex> lk(_mutex);
>>   				++_searchProgress;
>>   				_pbCond.notify_one();
>> @@ -100,6 +109,7 @@ size_t KsFilterProxyModel::_search(int column,
>>   
>>   				if (l)
>>   					l->setText(QString(" %1").arg(matchList->count()));
>> +
>>   				QApplication::processEvents();
>>   			}
>>   		}
> 
> 
>   Otherwise it looks like it leaves out the final update and the
> code hangs here:
> 
> 	/* Start all other threads. */
> 	for (int r = 1; r < nThreads; ++r)
> 		maps.push_back(std::async(lamSearchMap,
> 					  startFrom + r,
> 					  false)); // notify = false
> 
> 	while (_searchFSM.getState() == search_state_t::InProgress_s &&
> 	       _proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {

Alternative fix can be to changing the above to:
	       _proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads - 1) {

I would say we can apply both. What do you think?

Thanks!
Yordan

> 		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
> 		_proxyModel._pbCond.wait(lk);
> 
> < It's stuck above >
> 
> 		_searchFSM.setProgress(_proxyModel.searchProgress());
> 		QApplication::processEvents();
> 	}
> 
> 
> -- Steve
> 
