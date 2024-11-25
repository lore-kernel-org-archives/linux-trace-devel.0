Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4575E376E0
	for <linux-trace-devel@vger.kernel.org>; Mon, 25 Nov 2024 11:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535423; cv=none; b=NaYYpRPHgLpszByvIGJwID7xUv5tBC+XLSjMc7vr+m/tPWa5K8SYyN/aN3Q3+0VFqfQpZ/ljr/AbYBclQElnI9d7wrL56PcuwM0x7sTqt7W8h4cIjL2KtEgaL2IgBLSbyO2UK1Pw1iZGruLgHMdEd+Zr+9mddvN0YCOn458WpE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535423; c=relaxed/simple;
	bh=n4DrUtmXPmNFHdfQYq/WFdmXGKV1xau0E6RYfw2v9n4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IPAldzYvHw6FrRXQp1z8/9dwXu3flqN+/QwDP/PVg1XfR+SUB3zqCTCFzaNab0oUQ76+CB9ZDEM+CWS4Mhwvz+cbhMV0XTY2+ldlmAPooKZNHP3p+Be9fATukG+MEfph0LT4Z70eMFc4QbH2o0unrKp9tj1aX6+hl0d/4XcJXpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B63D51692;
	Mon, 25 Nov 2024 03:50:49 -0800 (PST)
Received: from [10.1.37.38] (e132833.arm.com [10.1.37.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA21E3F5A1;
	Mon, 25 Nov 2024 03:50:18 -0800 (PST)
Message-ID: <16ca253d-4598-4ee9-9b92-4412a689f059@arm.com>
Date: Mon, 25 Nov 2024 11:50:16 +0000
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] trace-cmd: libtracecmd: Rename private functions to
 fix static building
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
 Douglas Raillard <douglas.raillard@arm.com>
References: <20241119153300.1668429-1-metin.kaya@arm.com>
 <20241122164914.1ffdd809@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241122164914.1ffdd809@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/11/2024 9:49 pm, Steven Rostedt wrote:
> On Tue, 19 Nov 2024 15:33:00 +0000
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
>> diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
>> index b6b44f58..6b8e40f4 100644
>> --- a/tracecmd/trace-agent.c
>> +++ b/tracecmd/trace-agent.c
>> @@ -32,11 +32,11 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
>>   	int i, fd, ret;
>>   
>>   	for (i = 0; i < nr; i++) {
>> -		fd = trace_vsock_make_any();
>> +		fd = tcmd_vsock_make_any();
>>   		if (fd < 0)
>>   			die("Failed to open vsocket");
>>   
>> -		ret = trace_vsock_get_port(fd, &port);
>> +		ret = tcmd_vsock_get_port(fd, &port);
>>   		if (ret < 0)
>>   			die("Failed to get vsocket address");
>>   
>> @@ -199,8 +199,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
>>   	if (ret < 0)
>>   		die("Failed to receive trace request");
>>   
> 
>> -	tsync_proto = tracecmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
>> -					       tsync_role);
>> +	tsync_proto = tcmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
>> +					   tsync_role);
> 
> I'm fine with this change in general, except for converting any function
> name that starts with "tracecmd_" that is in the tracecmd/ directory. Yes
> it's marked as hidden, but these are functions that are not quite ready to
> become API, but are planned to.
> 
> I used this as a general notation. If it starts with "tracecmd_" and marked
> as __hidden, it means that it is still a WIP API. If it is marked with
> "trace_" it is just a direct hook between trace-cmd and the libraries.
> 
> Care to send a v3?

Will do, but there is no function starts with "tracecmd_" defined under 
tracecmd/ directory. Should it be lib/trace-cmd/ instead?
IOW, I should *not* rename the functions below. Correct?
- tracecmd_copy_trace_data()
- tracecmd_filter_free()
- tracecmd_filter_get()
- tracecmd_filter_match()
- tracecmd_filter_set()
- tracecmd_tsync_get_proto()

Thanks,

> 
> Thanks,
> 
> -- Steve
> 
> 
>>   
>>   	if (use_fifos && open_agent_fifos(nr_cpus, fds))
>>   		use_fifos = false;
>> @@ -223,9 +223,9 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
>>   				remote_id = -1;
>>   				local_id = -2;
>>   			}
>> -			fd = trace_vsock_make_any();
>> +			fd = tcmd_vsock_make_any();
>>   			if (fd >= 0 &&
>> -			    trace_vsock_get_port(fd, &tsync_port) < 0) {
>> +			    tcmd_vsock_get_port(fd, &tsync_port) < 0) {
>>   				close(fd);
>>   				fd = -1;
>>   			}
>> @@ -327,13 +327,13 @@ static void agent_serve(unsigned int port, bool do_daemon, int proxy_id,
>>   		if (listen(sd, 5) < 0)
>>   			die("Failed to listen on %d\n", port);
>>   	} else
>> -		sd = trace_vsock_make(port);
>> +		sd = tcmd_vsock_make(port);
>>   	if (sd < 0)
>>   		die("Failed to open socket");
>>   	tracecmd_tsync_init();
>>   
>>   	if (!network) {
>> -		cid = trace_vsock_local_cid();
>> +		cid = tcmd_vsock_local_cid();
>>   		if (cid >= 0)
>>   			printf("listening on @%u:%u\n", cid, port);
>>   	}

