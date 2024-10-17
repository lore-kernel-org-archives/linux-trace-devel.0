Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9731CEAA3
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 08:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153188; cv=none; b=Bgw/Yp/RLVlxgBruFBFXoKntTfTnD6tulcAUkps93Fh4cSF5MFNAUBuJM1n5aWZCiBzDoEyySuYvkV0SlvOc9G9sS2tGLbJ/rhP5mSvx1Bl9Bqpyvkgzz5uQ/zh/JTwlWk0GoiWPP3IlNSccPivq2rQyVV5qI6/53tFKnyXSuwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153188; c=relaxed/simple;
	bh=LCJR/YDYNxOMSzLvWBux5q43VtKY0XmtD04tUB91Xcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJBjTeP8MydjMS7iMutcLekR1gyRhZKRl+lJcd9FDbhKLserGvL8Evo3435wndIodjBlCCRDzWqZNn97MVVjrMahlL3FzwVWVqhPmhNNsoN7urjIeRuHx5kUjpH0vybxcn4pgCwNhfM5fMGu0QJoRDHcve7JjtSyYWUCRnt4xhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD21AFEC;
	Thu, 17 Oct 2024 01:20:13 -0700 (PDT)
Received: from [10.57.21.119] (unknown [10.57.21.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7D003F71E;
	Thu, 17 Oct 2024 01:19:43 -0700 (PDT)
Message-ID: <51073f99-b44f-415b-b50d-9a1b71383280@arm.com>
Date: Thu, 17 Oct 2024 09:19:41 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libtracefs .gitignore: Ignore utest/trace-utest in git
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20241015154502.4189900-1-metin.kaya@arm.com>
 <20241016125115.4f48dc88@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20241016125115.4f48dc88@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2024 5:51 pm, Steven Rostedt wrote:
> On Tue, 15 Oct 2024 16:45:02 +0100
> Metin Kaya <metin.kaya@arm.com> wrote:
> 
> I'm applying this, but even the most trivial patches must have a commit
> log. There should never be an empty commit log (except for whitespace and
> spelling fixes).

Exactly. I kind of had lack of creativity while writing the commit.

> 
> I added this:
> 
>      The test program utest/trace-utest is created by "make test" and should
>      not be tracked by git.

Thank you! Will copy this to my other .gitignore patch in trace-cmd [1].


[1] 
https://lore.kernel.org/linux-trace-devel/20241015154413.4189532-1-metin.kaya@arm.com 


> 
> -- Steve
> 
> 
>> Signed-off-by: Metin Kaya <metin.kaya@arm.com>
>> ---
>>   .gitignore | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/.gitignore b/.gitignore
>> index 3e72a58..7e61473 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -13,3 +13,4 @@ tfs_version.h
>>   *.o
>>   .*.d
>>   sqlhist
>> +utest/trace-utest
> 

