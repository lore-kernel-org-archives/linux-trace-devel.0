Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="bY94BDnv"
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC87383;
	Tue, 28 Nov 2023 12:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1701202939;
	bh=bhG1yghSDSxAqQrK6QfRaIKi0WYVzVg3O2DnJYKJMaU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bY94BDnvUdmQpOagzeI2COoL78Rk3plKMw/mzrGb7/dFj+bS8q2f5X1k9QnNL5t6l
	 ZhRc92gtmL+ovtQWOrMPjTBuKv6yJRJBAkj8DRN9Xv/tDu8okBZlgzG6pHSKHJYFd9
	 hheASXPzdcvzRiSHpff5OaBpPtcTjn9BIWww6tkNQ81U8L9l54q9pAJdaNq5B/8XUR
	 NShLMsI0QIdP2YSGiBmDHH/sj9eFlYLmiDX4AlhyJrZ/0dC6c8WqoVMLGs6yJXPshZ
	 IN7H/VIykqyeKtG2IvPRekIG670F6l7NTDJf2Hnorn6+wJLoBAquEqK7Au8owZ58Uj
	 D0/OjM4mEA7PQ==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4Sfv573gBbz1dDK;
	Tue, 28 Nov 2023 15:22:19 -0500 (EST)
Message-ID: <7be74990-505d-44c3-9d62-5c4147778877@efficios.com>
Date: Tue, 28 Nov 2023 15:22:19 -0500
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] trace-cmd record: Reset PATH variable after strtok search
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>, David Vernet <void@manifault.com>
Cc: linux-trace-devel@vger.kernel.org, linux-trace-users@vger.kernel.org,
 kernel-team@meta.com, julia.lawall@inria.fr, himadrispandya@gmail.com
References: <20231128192435.36507-1-void@manifault.com>
 <20231128143044.72f0925e@gandalf.local.home>
 <20231128200856.GA431764@maniforge> <20231128201302.GB431764@maniforge>
 <20231128151823.185839b8@gandalf.local.home>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20231128151823.185839b8@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023-11-28 15:18, Steven Rostedt wrote:
> On Tue, 28 Nov 2023 14:13:02 -0600
> David Vernet <void@manifault.com> wrote:

[...]

>>> That would work too, though I don't think strtok_r() is doing anything
>>> useful at that point. IMO it's better to either do the setenv() with
>>> saveptr, or change that strtok_r() to a regular strtok().
> 
> I always use strtok_r() over strtok() just because it's "safer"!
> 
> I know it's not necessary, but the number of times I had to switch it to
> make the code thread safe, I just decided to always use it. Just my personal
> preference.

And if you want to make your code thread-safe, you should favor working 
on a strdup() copy rather than modifying the argv or env content.

Also, modifying global state prevents code from being eventually re-used 
in libraries.

Thanks,

Mathieu

> 
> -- Steve
> 
> 
>>>    
>>>>
>>>> Although, I still need to test the result of strdup().
>>>>
>>>> -- Steve
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

