Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B41386440
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2026 08:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777017974; cv=none; b=rZ5ZNkjKSk1wvZZp7JT1T2Vi29YqLtWbC0eaYOqgVB46faZbLyzKyau5V6b60cAtzQNGy7uI8Uq0ltXJpdBR4vivL6g2vZ+GD6lWHPYPDGaE2K1umfIqV3/45cPD6xQcDSFE4i8hvKYuP5DsEFzYO1cExKnrssW0fag9NHIHP6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777017974; c=relaxed/simple;
	bh=KqSXeyhYgZMbK3ruuuvu1Vu92IB/0KLduG+/zwc5UW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=otQsyIxzcobgPLv6cet+vuhbrYToJ38mFha4fgnT/Ma0rFfq60FdF9CKoQyBtDYd6HpVglFXcTKuxHy55KFhHfl+srsi/eXjNLiMMpP3YywVyCq+nmrMqOL1ChXAsDUPMNnsfJh3kgXusGSgb0XPEJx0ACiU+cLJhkFPhaIVIZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JlgeXXi0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JlgeXXi0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF5B61BC0;
	Fri, 24 Apr 2026 01:05:58 -0700 (PDT)
Received: from [10.57.22.222] (unknown [10.57.22.222])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF5C23F641;
	Fri, 24 Apr 2026 01:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777017964; bh=KqSXeyhYgZMbK3ruuuvu1Vu92IB/0KLduG+/zwc5UW4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=JlgeXXi0JeMwGpg79gH960BMnziAnSud7s2bDSSVAVTXhfGpo0tSG2O/AMRUtTbob
	 0Evan210zymUgoCIvgQ4p19ZYGHpSbx+cJfCQjPOYec0P/xqxqfS5+2BS78bA+lpor
	 jr19X7RwngFmKTwdyhKYQstBI+DrSkTISN3SNg54=
Message-ID: <0f12f980-2d76-401d-a88d-6b85bfb11579@arm.com>
Date: Fri, 24 Apr 2026 09:06:01 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tracefs: Fix tracefs_dynevent_destroy_all()
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20260423162054.3fd36a5c@gandalf.local.home>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20260423162054.3fd36a5c@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/04/2026 9:20 pm, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> There was a regression with tracefs_dynevent_destroy_all() where removing
> kprobes (or other dynamic events) if it checks another event that doesn't
> exist, it returns zero and not the current count. Then the "all" clearing
> thinks it didn't find any events and returns without doing anything.
> 
> Have get_dynevent() return the current counter if it doesn't find events and
> even if the tested for event file doesn't exist. As that tested file may not
> be the dynamic event we are interested in.
> 
> Reported-by: Metin Kaya <metin.kaya@arm.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221395
> Fixes: 78d8d2e277af2 ("libtracefs: Have tracefs_dynevent_get_all() find kprobes and uprobes properly")
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>   src/tracefs-dynevents.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index 5fdb723b6825..ad879ecbbc68 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -499,12 +499,12 @@ static int get_dynevent(enum tracefs_dynevent_type type, const char *system,
>   		return -1;
>   
>   	if (!tracefs_file_exists(NULL, desc->file))
> -		return -1;
> +		return count;
>   
>   	content = tracefs_instance_file_read(NULL, desc->file, NULL);
>   	/* File exists, but may be empty */
>   	if (!content)
> -		return 0;
> +		return count;
>   
>   	if (ret_all)
>   		all = *ret_all;

Hi Steven,

The test cases I mentioned in the Bugzilla pass with this patch.

Thanks,

Tested-by: Metin Kaya <metin.kaya@arm.com>
