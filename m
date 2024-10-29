Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD581DF243
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183197; cv=none; b=aPsEdJPKV4xJzl2WMTAy6yVfia6SCI96pGMZcpuhBVWdQFMWETeY5FFnBRRCbjdMfge/UapD3bpgJtAAaLfTT/sbj/EVtFPGcp+1ONErl69MpRHISYZV8S3ujFhQVuuNZjb813LmWYIa2zkx+7WYRIbaL53d1daO8lNUdpktrYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183197; c=relaxed/simple;
	bh=teFlDRLGcve0h0VM3908V92ag2wcxPkjtpGDkBu8fic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GXIm9R6qTACSVipkQdQYXf70L7fYfa6AntOprPIMqBmLE8JfGWrTq9RGcDmI2lFuGYXHlfzsJuJE7o88npqofrpt1wrLPlMjwj3jKwYdskIsuaUhfLd44hgfjE7fLZ3cHHZ/J/fMzt2RvLmkTnAId7iICX0R+vbgmTHMuMhH/O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GQ872FF9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQ872FF9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3HSkBFif48WCfm5xljA5kOm8S6LMvdjxCC6pAk23cRA=;
	b=GQ872FF9ha1PGK1uKvsjXi1DlZRwxIMMx8D6knt80xpVSjORFCKebokwQcPE4Cf+k0nowj
	YiTgSVKhVM62MRM02VVd1DL/2XkMLw01egQEi4icYnzc6hWavau2OGOy42zW81WSDc+ogl
	dKY5Qx1mzbvPflIKia8Rke4lO3OrV0I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-s83J2n_WPziJPYhiy5BtgA-1; Tue, 29 Oct 2024 02:26:31 -0400
X-MC-Unique: s83J2n_WPziJPYhiy5BtgA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d458087c0so3569178f8f.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183190; x=1730787990;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3HSkBFif48WCfm5xljA5kOm8S6LMvdjxCC6pAk23cRA=;
        b=bPFnokUEA2yJuWChorPZ3zrUhai/npj5JJD2rRC+mZLTqyQ7sj/ECPcGaZr+9ABIis
         MHRiWDV0DP8UTp4v6uvUlGK/LZiePBSRv1fdDwMwogszB0tUHgXhb96jUOLop5xAd1NV
         AGhAlMW8/Er0voaTmM2t97h2ceZ9ZdxDXKD763JbMVl7oqRN+cb12EH+5eNH6DHOYDd5
         tqUOuxNsFlAbRFb9oQX0Ris6Z+ZSpcxtbKQlTq8jbfJi+Ik3Vvgmr7mgiymkIf/Jll7n
         TtMEGbL8RTOqz4wPurkzMYFwyYOA+V6jRSI0uBXs39QYooliLPuuVrB28L+R+wGuVitr
         G/dg==
X-Gm-Message-State: AOJu0YyvvCGx9mW0lxk7yHh2FA+IM1mo6iijhHaKrCtb8ZeYJYc/l2fA
	96K/0ZhlL6IqI4aY8UsIebj/+rmR0dC1y1JZHnr/ryTb8enLmvARNlruDic7cYELMDJhGIN4q80
	fDWmq10+oihVJgIkJ5DBMVW5vns5lJ6wl+s7k7NOnJ6mfcrzWidI0ZNlFJyOYzY3drYGtzltRIf
	B2
X-Received: by 2002:a5d:6603:0:b0:37c:cce8:4acc with SMTP id ffacd0b85a97d-38159d83653mr623185f8f.13.1730183189727;
        Mon, 28 Oct 2024 23:26:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdROO3MnKdHEryU32KlbWozQ8MvoRnexHHS3lVSMO/0NGPFhYdfdYFPD/LUCRIffNkI32qgw==
X-Received: by 2002:a5d:6603:0:b0:37c:cce8:4acc with SMTP id ffacd0b85a97d-38159d83653mr623174f8f.13.1730183189382;
        Mon, 28 Oct 2024 23:26:29 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3c1f7sm11558948f8f.43.2024.10.28.23.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:26:28 -0700 (PDT)
Message-ID: <9ee7426a-5117-46c4-a9cf-c669385a3167@redhat.com>
Date: Tue, 29 Oct 2024 07:26:28 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/38] trace-cmd lib: prevent a memory leak in
 create_event_list_item()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-9-jmarchan@redhat.com>
 <20240717163119.0c3e816c@rorschach.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717163119.0c3e816c@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

Sorry for the long delay. I was on PTO and then this got at the bottom 
of my pile.

On 17/07/2024 22:31, Steven Rostedt wrote:
> On Wed,  5 Jun 2024 15:40:23 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> Free ptr if malloc() fails.
>>
>> Fixes a RESOURCE_LEAK error (CWE-772)
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   lib/trace-cmd/trace-output.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
>> index 59498edc..4a9ecc5d 100644
>> --- a/lib/trace-cmd/trace-output.c
>> +++ b/lib/trace-cmd/trace-output.c
>> @@ -955,7 +955,8 @@ create_event_list_item(struct tracecmd_output *handle,
>>   	free(str);
>>   	return;
>>    err_mem:
>> -	 tracecmd_warning("Insufficient memory");
>> +	free(ptr);
>> +	tracecmd_warning("Insufficient memory");
> 
> This function starts with:
> 
> 	char *ptr;
> 	char *str;
> 
> 	str = strdup(list->glob);
> 	if (!str)
> 		goto err_mem;
> 
> Where ptr is not defined yet.
> 
> I'm going to skip this patch.

After taking an other look at this, it looks like it was a false 
positive of the static analyzer anyway.

Jerome

> 
> -- Steve
> 
>>   }
>>   
>>   static int read_ftrace_files(struct tracecmd_output *handle, bool compress)
> 

