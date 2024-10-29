Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5187B1E0B93
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183475; cv=none; b=sLyGLTMHpL976NHqv3zkdSURd+WiJHKg4anfO34aLedC6AXCGMUy28FXMuUzQRuohjVCjqyzz7qQ1pL5u4u7+5xPrS0AAXX4xghTrw2UctHCJ66oFf7KRjMb4AzO/24seJQnfCXnYsq693FC6K6dT7dr8he3GYLBp5q3u2nPxK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183475; c=relaxed/simple;
	bh=oMgKs41ivLixYwsYIlCtK1EmySQr2ThG1xI4eiJyxuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4fT52BCUy/xT7migAUsSDRRGqLYefAQ6DpaqICKxMU0V8yBsIKsAjno+C1k8xY8ilOINXdyAc6ZeVG0x4tXND/fPx9dZQUmRHg0pcmYV7GZ4ubCvlaWaXz/nOs9NoQmMqegyPfKKTsoM32J6KuZZz6tMeS/1Z5qduIBAaVJs8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DtXvgac+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtXvgac+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3u6aPY4lw7aoG3dsiWKHP/mT7w9yiTXqj91vt/x0y4=;
	b=DtXvgac+bMCyUopnWkLQaKBJi+YCDsjYONbVgr4VY46iC3Xwv7+f28RZ4IH/WHz/zpbt0b
	lspKE7y22yi2d1fzax5APFNs6DWUtitL/HjU0kFMbs0YQq/Kp+ByGCKYeH2cEfA7zqu/9s
	Fq+/0bTDFysbQrGb87cgIt25ov9eVXE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-_yCIjiD0M_2oaaZmVypyyQ-1; Tue, 29 Oct 2024 02:31:10 -0400
X-MC-Unique: _yCIjiD0M_2oaaZmVypyyQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4315d98a873so35160225e9.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183468; x=1730788268;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3u6aPY4lw7aoG3dsiWKHP/mT7w9yiTXqj91vt/x0y4=;
        b=Db6S8+1mE1dNhbRn381Uazpg9UGInmYrQ3kBKadaRW5BCZBSEJkzROSEYTThtX3Hnf
         1EuSYZiuo0zPxV2EIv5Ppp6vEmETgL7eMkBeeWfGEU6YCRTMcpIYM5S6Mh4doAot6WF4
         sLDonbohWFeP2+PG0IJ4QgwoWTIJ+RFrwAL35JwnqX09WfSQq6lH65kQ9u/0HYLgx/Cq
         lX9HL7JvFqzL4hmon0w7oMIY+C0UOvrwKAspPFnjsGjRZcLp0AyCvUumdAIp3YIlMa9f
         B5uBR9xE9hZTtyVkguV+w+8dZJMDrGJBeIc/q4iTjmnpiylpWwpyWXf1Gw5TDKcEnOzO
         Alfw==
X-Gm-Message-State: AOJu0YxH6sfQoFwmBCSIeumOTxSS7BoyairG54g67l5shPdpdBWyoIpl
	JWRY6mjQCbXaIrVXoSeDxQ/fWKfizIHpm9RH9yRh9WBQQErIC48zNRqODgy+Va/X64O46nmnSPq
	z6eX0cQFbariIWIPui4q+RbhI1xyOTFg0tIVmqoBwOKOdcc6oFetaiBxc4mCVG/p+V9IjnCG2Tf
	96
X-Received: by 2002:a05:600c:1c14:b0:431:5871:6c5d with SMTP id 5b1f17b1804b1-4319ac6faefmr100158845e9.3.1730183468113;
        Mon, 28 Oct 2024 23:31:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9RB3imj/n/ERLCW8rnRXwjtXTSMJaHW/qDwlhp+GV5tgqBvv7UYq3E875Sb8QO2aROHJC1g==
X-Received: by 2002:a05:600c:1c14:b0:431:5871:6c5d with SMTP id 5b1f17b1804b1-4319ac6faefmr100158685e9.3.1730183467727;
        Mon, 28 Oct 2024 23:31:07 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b5707e8sm163435045e9.36.2024.10.28.23.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:31:07 -0700 (PDT)
Message-ID: <daa77477-5c02-4585-a381-5c7d02ca7ecf@redhat.com>
Date: Tue, 29 Oct 2024 07:31:06 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/38] trace-cmd record: prevent a memory leak in
 show_error()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-14-jmarchan@redhat.com>
 <20240717165143.7259d261@rorschach.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717165143.7259d261@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/07/2024 22:51, Steven Rostedt wrote:
> On Wed,  5 Jun 2024 15:40:28 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> In show_error() the pointer p is used for several functions. At some
>> point it is used to contain the error log file. It's not freed before
>> being replaced by the result of read_file(path), which is not freed
>> either. Free p in both case.
> 
> This isn't that big of a deal as this is just an application that is
> about to exit anyway. But I'm fine with freeing it. That said:
> 
>>
>> Fixes a RESOURCE_LEAK error (CWE-772)
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   tracecmd/trace-record.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
>> index f05a58d1..3e29f922 100644
>> --- a/tracecmd/trace-record.c
>> +++ b/tracecmd/trace-record.c
>> @@ -2364,13 +2364,16 @@ static void show_error(const char *file,
>> const char *type) goto read_file;
>>   		}
>>   		read_error_log(p);
>> +		free(p);
>>   		goto out;
>>   	}
>>   
>>    read_file:
>>   	p = read_file(path);
>> -	if (p)
>> +	if (p) {
>>   		printf("%s", p);
>> +		free(p);
>> +	}
>>   
>>    out:
> 
> It would be much cleaner to just add:
> 
> 	free(p);
> 
> here, and remove the above two calls.

Good point. I'll update the description which is incorrect too.

Jerome

> 
>>   	printf("Failed %s of %s\n", type, file);
> 
> I'll skip this patch too.
> 
> -- Steve

