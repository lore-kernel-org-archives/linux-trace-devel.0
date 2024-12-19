Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B7215B115
	for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2024 09:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734599190; cv=none; b=A4g5JVZVqQK0VNKpqgaZ344vXq3TSegE0ZSKmOjXt6bCk8GH2DflbA6XuO+CTu7r8X2tIi36Miy6mk1Qht6DBQnTUlJD4Ifk2ZjJy0CXHyx1f+eamA3ECVgveVVxbPAKGLsr57PeQYAXPuqgERciO46Bc+M7q3XVlCa4CWs3Vkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734599190; c=relaxed/simple;
	bh=qVbwhefE0W/oG1g7QmADTKGKpXZD/ftQqX5Q8+KvCAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NAxJjzgDDCBSb3yuniMc8nW0rq2ic8A3ftW9Kfvu1l5V7xQWBg9uVDVlQY9MezDL0ktU7oc4WTfiQuYSCe32MZLgBDei4O/7zGTN3ZMohy19xaB/xDc5b9BD7Dv8nqUmZjQYNSALOeTtVoGqinfX3oAmep7mBZvjDXBemC2vnXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYUDpcbf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYUDpcbf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734599188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MBcMhwoLuhu/l7R2ajdSbBL0MdGpkhussC80Rx3I5wM=;
	b=JYUDpcbfG4NSEUIDEqc56ca+7fY5VmbGeOIPfKP+61FVTw6+GnyoT8XXJttd7DpS8C6xLP
	+BZzDMebIukR4RHjQRvzttz3CXkw8J0CdF7WnpxUY+kD1v1yilWlfZiB3vScGRMnMGXNUP
	GFx0Xw+ShEK86HrxBmjsIWIaTlxr+5w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-ELraz40sPWeGWEk4jkcUjQ-1; Thu, 19 Dec 2024 04:06:26 -0500
X-MC-Unique: ELraz40sPWeGWEk4jkcUjQ-1
X-Mimecast-MFC-AGG-ID: ELraz40sPWeGWEk4jkcUjQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3862be3bfc9so371786f8f.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2024 01:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734599184; x=1735203984;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBcMhwoLuhu/l7R2ajdSbBL0MdGpkhussC80Rx3I5wM=;
        b=OZd9uTre18XVVb3KfmRfnTfsQMsjTqAlsNHTD/SBRdxJa+eYAQxE2frf4RQ3a5/ocd
         xuJPgtwALGFGy6i+NGvWv6h5tNRpyNZEgCdvZ+A6shI+I+qkQuNokcx49JxLjsjefnHR
         R3EGsIVDHCOD/P9r+hVNu6KACP2K8SfiWylmDhNHhcwmkEUg95KtF1cskX8RZcgVrr+2
         +8jxaixA1xbab0Ne7yskFKDFwIy0XyGAhHzcrl9JC7qAGeWddWxaq/j03OMv3GBxqrWz
         rnehQDyK0s4VuLov4ob1MhFiYEDaqRTihRqYCBU5tUu2mvmB4tUZ77z/NOVyqhhvd0aY
         zV3g==
X-Gm-Message-State: AOJu0YwbNGtqWeMbrnRFwL/v/al80f3xqqa05E2lWvQqFhm5wSKThTb2
	ZxnAyqCVYdZ4DRkpiWl2RFy2THSQC7C5j7F8GjMHKdjBNLDW2CWS0efR01R4Uc/y3Q289Oedkq4
	18ebHQZwFPY4IQ4va0qoZ3eQ2lyDqnEo6G/ZC35j1M8mobRCzx5o5yRwoBszmrQdFnEk6aa5tM+
	2P
X-Gm-Gg: ASbGncuQqV4mJpaq32O++9KkwZ0+q4OLoyw8yZ9PgikuE332p9TAmlaZJG+PRXLYh+/
	3Wcfb2UJ4apCg9uQp3aVclz9PdKtWGlntybOk4+RP1sPB8ZnxnQlbE04ax/Ptfmzp9sy+3P5KCN
	hEivRC68DfZfCmeS4eGI4k6zK7TODVramaFD64ZxVWgDJuLb3hvx911ZzhzcAM6hcMdDYGBy/Fu
	SMTChfFcKLMYIaEsgEyd8Xc8s+tYameAeSGgAngHP5uM7lHCmj39XN0X0gLRhkxh59jUQEqPfeI
	XpyP7tc=
X-Received: by 2002:a05:6000:1faa:b0:385:f1bc:765c with SMTP id ffacd0b85a97d-388e4d2f7bbmr5575058f8f.6.1734599184580;
        Thu, 19 Dec 2024 01:06:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGNcZzYPRBTlFvymfH/5xWQy7C01Iyf99vYlMI6QJROYuFIuToKIuy9IKvyVsl/LiI21sOHow==
X-Received: by 2002:a05:6000:1faa:b0:385:f1bc:765c with SMTP id ffacd0b85a97d-388e4d2f7bbmr5575030f8f.6.1734599184192;
        Thu, 19 Dec 2024 01:06:24 -0800 (PST)
Received: from [10.43.17.16] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b441bbsm45639075e9.40.2024.12.19.01.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 01:06:23 -0800 (PST)
Message-ID: <6cc7ed3c-281e-4d52-983d-5cd87cbee705@redhat.com>
Date: Thu, 19 Dec 2024 10:06:23 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] trace-cmd: Fix misc issues uncoverd by static
 analysis
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20241205144439.127564-1-jmarchan@redhat.com>
 <20241218175343.6207107f@gandalf.local.home>
From: Jerome Marchand <jmarchan@redhat.com>
Content-Language: en-US
In-Reply-To: <20241218175343.6207107f@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/12/2024 23:53, Steven Rostedt wrote:
> On Thu,  5 Dec 2024 15:44:32 +0100
> "Jerome Marchand" <jmarchan@redhat.com> wrote:
> 
>> More issues were found by running static analysers on the code
>> of trace-cmd with openscanhub[1].
>>
>> [1] https://fedoraproject.org/wiki/OpenScanHub
>>
>> Jerome Marchand (7):
>>    trace-cmd lib: Close FDs in create_buffer_recorder_fd2 it allocation
>>      fails
>>    trace-cmd lib: Prevent a memory leak in tracecmd_tsync_with_guest()
>>    trace-cmd lib: Prevent a leaked FD in
>>      __tracecmd_create_buffer_recorder()
>>    trace-cmd lib: Prevent memory leak in tracecmd_msg_wait_for_cmd()
>>    trace-cmd sqlhist: Initialize name in trace_sqlhist()
>>    trace-cmd: Fix memory leak in stop_mapping_vcpus()
>>    trace-cmd record: Fix stdin redirection to /dev/null
>>
> 
> I'm going to apply all your patches except the two that deal with file
> descriptors. The functions should not be closing file descriptors that they
> did not open. The real fix there is to remove where it does close the file
> descriptors and move the closing in the error paths of the callers.
> 
> I must have gotten lazy and just let the functions do the closing when they
> failed, but that is just prone to bugs.

That makes sense. I'll send updated fixes after the holidays break.

Thanks,
Jerome

> 
> -- Steve
> 
> 
>>   lib/trace-cmd/trace-msg.c      |  4 +++-
>>   lib/trace-cmd/trace-recorder.c | 19 ++++++++++---------
>>   lib/trace-cmd/trace-timesync.c |  1 +
>>   tracecmd/trace-record.c        |  2 +-
>>   tracecmd/trace-sqlhist.c       |  2 +-
>>   tracecmd/trace-tsync.c         |  1 +
>>   6 files changed, 17 insertions(+), 12 deletions(-)
>>
> 

