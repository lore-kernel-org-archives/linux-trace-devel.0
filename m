Return-Path: <SRS0=xHrW=KR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34788 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732276AbeHBOuh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Aug 2018 10:50:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id l2-v6so2243311wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Aug 2018 05:59:31 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization model
 used by the Qt-based KS
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
 <20180731135248.30587-4-y.karadz@gmail.com>
 <20180801142244.3ed8a35c@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <a886af06-9a25-7c4a-e147-d970e9b9fd08@gmail.com>
Date: Thu, 2 Aug 2018 15:59:39 +0300
MIME-Version: 1.0
In-Reply-To: <20180801142244.3ed8a35c@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On  1.08.2018 21:22, Steven Rostedt wrote:
>> +	/*
>> +	 * Calculate the new range of the histo. Use the bin of the marker
>> +	 * as a focal point for the zoomout. With this the maker will stay
>> +	 * inside the same bin in the new histo.
>> +	 */
>> +	range = histo->max - histo->min;
>> +	delta_tot = range * r;
>> +	delta_min = delta_tot * mark / histo->n_bins;
>> +
>> +	min = histo->min - delta_min;
>> +	max = histo->max + (size_t) delta_tot - delta_min;
> Took me a bit to figure out what exactly the above is doing. Let me
> explain what I think it is doing and you can correct me if I'm wrong.
> 
> We set delta_tot to increase by the percentage requested (easy).
> 
> Now we make delta_min equal to a percentage of delta_tot based on where
> mark is in the original bins. If mark is zero, then mark was at 0% of
> the original bins, if it was at histo->n_bins - 1, it was at (almost)
> 100%. If it is half way, then we place delta_min at %50 of delta_tot.
> 
> Then we subtract the original min by the delta_tot * mark/n_bins
> percentage, and add the max by delta_tot * (1 - mark/n_bins).
> 
> Sound right? Maybe we can add a comment saying such?
> 

Yes, this is a correct explanation. I will use it as a comment in the code.

Thanks!
Yordan
