Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9901E0B93
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183500; cv=none; b=cO0IlRTk3a65yp4vM+1uzmSk/PNLDzcZAikt7Gh5+XmkEuxg8SrT03O8oU247K/DmasMsAz7JCxQZgKx9zZxRhXGEsjZ/hIz4dC5JtTNNfe6FqfCfeXcULB4BjQSsUQ+C7R2aK+rQbm0GgP/0G+CQnJMTwtrsUHsFl3cO9jOFX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183500; c=relaxed/simple;
	bh=Q4JnZMZTINZ2zGa/mZhg5TwWquh0Jrm089R+6WHmYbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bqN4q8zttpt8kU92cp1ND3C6t3Q82ZL+dcDqbMNyLZ+PNh7IlFANFFf0VIdJG8SSMfGTYLfaHJKF2VRIcHffKtohCM1YxqEoYrKDU6cxBDbrmSRckGzWd0WIxCWdRveJVD7pFh6maUXNH4IEeRY+Hd+ZMBESGdj7r9SbQQzSy5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVKGjBYl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVKGjBYl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FGgLvMOTOaIxty6gUtCOeeuy6F7gycny2ZFQqx75fA=;
	b=QVKGjBYl+6DG3qGzjVnVrrIacmegvgSd2TDWuFBpFWjnjArKwgovLG+nJ2xXhRLZ99JhEE
	+pAYqv8cYailzqKNk0XRHdeUxr9f96OE0e3ux1yXup57PNHWnwdZY/aQRerwWibjEPB4ak
	/mgnkXvlV2pkjOEAriKQFh+qfO4IRLE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-0vglIk-SMrqapExdIAawZw-1; Tue, 29 Oct 2024 02:31:34 -0400
X-MC-Unique: 0vglIk-SMrqapExdIAawZw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43151e4ef43so33568085e9.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183493; x=1730788293;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FGgLvMOTOaIxty6gUtCOeeuy6F7gycny2ZFQqx75fA=;
        b=KVb1OwajqDDFZe8n8ojCglD4l21OrOMUqbrwyo+TsKKhgxq/pvzd/HJKr1+zuITwAy
         Bd/ucNNsa5ICFbBvtvi8GRzbdaBmlOwp11ib1gtKSbwFfFuARA0OWqIlNGwxV4XTJLTl
         o+QlcoZerYcFVkoRNMw5ve3ZNAFMqzCsuy5bVykVVf+tc/PXoaZaleoLh3Wd0p4TOLbw
         7Ni+92gc3CzAMW73ipiB/RVpnS6iYpsSco8JbpElm204Hq9lTOb/OY/NHEUsfaoWnFsJ
         YFvR1gOWAygYN+vmmc6NffOyjm67hyEo6BhkCpc/P6dl/Z40alDA5idDCggMM4zhyoW6
         COLQ==
X-Gm-Message-State: AOJu0YweCjZ5dOrOduE8HBZWcdL+A/3s49oFt4lGgLzV7VgGcRshAhXR
	OrLkaTCKG9Zr/y22e408O44KnOulXcAlJCVY9lQCPhVNgsVf4k/XvzpiGpRK5MiP3UFzE5VFGX2
	leffQNxjJ4CRMYsSo1K/GNKpBmvX0g6ZQ1SzV3BJgJGsQ/DfSFod2c90HXdJSGV14BiSc
X-Received: by 2002:a05:600c:35cd:b0:431:5863:4240 with SMTP id 5b1f17b1804b1-4319ad0f10cmr90916345e9.24.1730183493495;
        Mon, 28 Oct 2024 23:31:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFti3oWHlAyB1uX6H2NYyRTj67LjKDFyNwm1TEPM9Yf2a/WAB/ZAx/ziggxyXCCiRdsYsGoQg==
X-Received: by 2002:a05:600c:35cd:b0:431:5863:4240 with SMTP id 5b1f17b1804b1-4319ad0f10cmr90916195e9.24.1730183493152;
        Mon, 28 Oct 2024 23:31:33 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431b4594ec3sm15067315e9.1.2024.10.28.23.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:31:32 -0700 (PDT)
Message-ID: <df309ae5-e97d-4d9e-8df7-b65a7e2fd67e@redhat.com>
Date: Tue, 29 Oct 2024 07:31:32 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/38] trace-cmd lib: check the return value of do_lssek()
 in trace_get_options()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-16-jmarchan@redhat.com>
 <20240717171030.03117c8f@rorschach.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717171030.03117c8f@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/07/2024 23:10, Steven Rostedt wrote:
> 
> Note the subject has a typo "lssek".
> 
> 
> On Wed,  5 Jun 2024 15:40:30 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> Check that do_lseek doesn't fail before calling malloc() with a -1
>> argument.
>>
>> This is flagged as an overrun error (CWE-119) by static anaysis
>> because of the call to read() later, but I don't imagine that malloc
>> would succeed.
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   lib/trace-cmd/trace-output.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
>> index 5ba0a145..35904620 100644
>> --- a/lib/trace-cmd/trace-output.c
>> +++ b/lib/trace-cmd/trace-output.c
>> @@ -2069,6 +2069,8 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
>>   	}
>>   
>>   	offset = do_lseek(&out_handle, 0, SEEK_CUR);
>> +	if(offset == (off_t)-1)
> 
> Nit, the above has whitespace issues:
> 
> 	if (offset == (off_t)-1)
> 
> Could you resend this?

Will do.

Jerome

> 
> Thanks,
> 
> -- Steve
> 
>> +		goto out;
>>   	buf = malloc(offset);
>>   	if (!buf)
>>   		goto out;
> 

