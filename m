Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762AC1E0B93
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 06:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730183528; cv=none; b=p68lP0p7oUUonyRHS0pwsbQjgNhCmH0eKNXw0AOj8sEWoyarX++G+M8TzfxWItuAMmnmJlIJ6lMX338oKmi62HqSrohD+aPpkXLwuqaNfvwFUUZvQjodByN46REes5Rj6n6XO3AYqISgpEKSi15OzlMifblQLMmobO6GhUOl1/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730183528; c=relaxed/simple;
	bh=ri6C1eU8yYphAswiLqzIXP5q8/a8k+dKu8nj3j3V7k8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y11I/WtZrfoYOpbaaufa+YeWrUNbX1VOJOyPWUSKm3VmX/xCzWIgNKkt4p0tXUXLsKTuy5XwIwvLb1g6Wrcbb9/RLzE43P68eNUjXxsYxf9BICggzdgJXdG2zt7uytwyx2rujSd+dLwINhBjq5IHEXqS8FRoxL23QA6xQRdPKRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gMLcyB8E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMLcyB8E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730183525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gjT9Mjmlq8FMasloEJoU5wfSqFm8tzgznddIsz1sp8=;
	b=gMLcyB8EEuq16AVd2Qp/86+WHNcngdyhVFKrM8L5GanJkFk2i8XLBu+LiIq5vyBygH53yo
	pe5UaMZJdQA3QFVypqZ1K1TUcG98rSH9jIIqedqdm92oH76moQBoefpHoiz/EAzgkSegys
	fFN0jexivs+xS3lHyA8jxdjdYJgGsKE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-yWGUHZwiNp2oasrZC2bJQA-1; Tue, 29 Oct 2024 02:32:02 -0400
X-MC-Unique: yWGUHZwiNp2oasrZC2bJQA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d4af408dcso2352178f8f.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730183521; x=1730788321;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8gjT9Mjmlq8FMasloEJoU5wfSqFm8tzgznddIsz1sp8=;
        b=G66hStIu200ZgI7Z6DiyS3FZZmUk7tejrFDw50oQlwigjITrKq/BNdSiW67Oxh5BXE
         5oJlWmctsVQZzbdONRA8n5x8SwLi4PEHZH7ouLOqytsEY08NPc6FiCvxvcd1tW8JKhcW
         uDKNM42RkI1NF70+l9wbYrXCk/DebyDDt5z7STXuwyNWnjoWbQwivMsf1t7gry7bV6HR
         A8eZUgdZZm9yWHIvWDL2vKD9Os+PilKMQjX3ekWwIIg6GhCWsc+jopULxGvh3K5DnSkU
         2nRH4cycsNZPHytzoC8WI2dIYUnWh59Z12vnuYh+CzyB/jtzmoGTic5U90qsBeUNq9Dy
         oviA==
X-Gm-Message-State: AOJu0YzveWTvTCGpzYzGvh6xWJZ4Dip2Cx1hdLa78j7K+KIgv2c9Unvm
	zaWMuV40uSrg5xAZ2rJRvK2YZeyVxvX2qYsYFm1o/SdSrCE7q6+4YWYCuWBJ4Xp0GqNhUaTnZ+I
	Q57sIfCFJBtldclHxB+EaEGiK303mg3ScVRqXmfWtYN4t6pP/L4nfS75xzkAjp0DBORsGYRtITI
	iA
X-Received: by 2002:a05:6000:1c9:b0:37d:49a1:40c7 with SMTP id ffacd0b85a97d-3806115a20bmr7750950f8f.28.1730183521429;
        Mon, 28 Oct 2024 23:32:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcSOPusM5xNsKFS190eOxLY372EDnnDdhUuW5LcIOFOHfYgX7I53QTtCRbkP/E323WuMMXkA==
X-Received: by 2002:a05:6000:1c9:b0:37d:49a1:40c7 with SMTP id ffacd0b85a97d-3806115a20bmr7750931f8f.28.1730183520990;
        Mon, 28 Oct 2024 23:32:00 -0700 (PDT)
Received: from [192.168.0.227] (ip-89-103-134-229.bb.vodafone.cz. [89.103.134.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b1c3absm11585359f8f.21.2024.10.28.23.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 23:32:00 -0700 (PDT)
Message-ID: <dde8e8e3-3244-4950-a4c7-ca9a3d906f7c@redhat.com>
Date: Tue, 29 Oct 2024 07:31:59 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/38] trace-cmd dump: prevent buffer overrun in
 dump_clock()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20240605134054.2626953-23-jmarchan@redhat.com>
 <20240717185521.0589659e@gandalf.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20240717185521.0589659e@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/07/2024 00:55, Steven Rostedt wrote:
> 
> Note, please start the subject with a capital letter:
> 
>    trace-cmd dump: Prevent buffer overrun in dump_clock()
> 
> On Wed,  5 Jun 2024 15:40:37 +0200
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> The clock isn't big enough to hold the string with the null
>> terminating character. Worse, clock[size], which is out of range, is
>> set to 0. Allocate a big enough buffer.
>>
>> Fixes an OVERRUN error (CWE-119)
>>
>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>> ---
>>   tracecmd/trace-dump.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
>> index 11c1baf1..c0a282c9 100644
>> --- a/tracecmd/trace-dump.c
>> +++ b/tracecmd/trace-dump.c
>> @@ -961,7 +961,7 @@ static void dump_clock(int fd)
>>   	}
>>   	if (read_file_number(fd, &size, 8))
>>   		die("cannot read clock size");
>> -	clock = calloc(1, size);
>> +	clock = calloc(1, size+1);
> 
> Also we follow the Linux kernel syntax. Please add spaces.
> 
> 	clock = calloc(1, size + 1);
> 
> Care to resend. I'll skip this patch as well.

Will do.

Jerome

> 
> Thanks,
> 
> -- Steve
> 
> 
> 
>>   	if (!clock)
>>   		die("cannot allocate clock %lld bytes", size);
>>   

