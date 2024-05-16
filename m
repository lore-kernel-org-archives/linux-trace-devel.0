Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB8136E3B;
	Thu, 16 May 2024 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845244; cv=none; b=Z8jVAUgIhY9cqaZoUupCuodSvEwdhH7HTp+Myau8tUfSUkJllGoicA8Tu97RMyaAM5QxoxJMJ6/SLJoGUCL01tMy6Tyi2PT3r2iLl5UbqyFwQKECFEopTv//XMnOAkSQ+munFAY8KunnN4UERyxUesulOyrBxzEr1jAPtkrB7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845244; c=relaxed/simple;
	bh=ae4/ycuiqXyjjoEk1olSQzsCd7I+zomglD2pv2TSTR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=ixp8NbKmqWZthNFPo1JevnPGtiUCdadFIl5ZArp7tIL+/rHly/i90bjAveNdtw08dPYnp7qflVhiZi1WLk+PlfEhMDAOWPYQQp0ULkGwsZUt9yuPMHrIE4wxeuv2UBu4H+ROwp22sLaVQxUyWoe8YgeehYA1DKu8RipjGuAONo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TXW8J4RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TXW8J4RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EA0C32789;
	Thu, 16 May 2024 07:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715845243;
	bh=ae4/ycuiqXyjjoEk1olSQzsCd7I+zomglD2pv2TSTR8=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=TXW8J4RYc+hbJjWwjy9jCb1Hp1WXmII+kOq/lYOZ9GNEQbF7gCbmpysgsKxtCvJz1
	 d8c22if6w/+jKU1JnJ0k7Z3PtpLsgwgemotWeqOVNvPidgtFDPwL4Kai3np/nRgGBX
	 hWVPUuTKR/aRvFbviW3CqnhmS1x+vmHI9zttS6eKj+t8bjys2ByzzhON9Bjbjow/SJ
	 Cie6BVx0fS58APCm8RA9Cdiamjj/z9m/6nscioV8DjVBpnQHfT7SX8xz/ReclgQxGX
	 Ahnqmn4GJR/bkGXfcsyRjYGXRtQ/NSKHVDFcyM53rPGXQZXXhCVRGJK7lxdJWtiEUg
	 GeJ9PjFa1dWMA==
Message-ID: <ff1ec7dc-2164-47bd-9046-4c6ad99947f7@kernel.org>
Date: Thu, 16 May 2024 09:40:40 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] rtla: Documentation: Fix -t, --trace
To: John Kacur <jkacur@redhat.com>
References: <20240515183024.59985-1-jkacur@redhat.com>
 <20240515183024.59985-2-jkacur@redhat.com>
Content-Language: en-US, pt-BR, it-IT
From: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml
 <linux-kernel@vger.kernel.org>, linux-trace-devel@vger.kernel.org
In-Reply-To: <20240515183024.59985-2-jkacur@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/15/24 20:30, John Kacur wrote:
> +++ b/Documentation/tools/rtla/common_timerlat_options.rst
					       ^^^^^^
> @@ -22,6 +22,10 @@
>          Save the stack trace at the *IRQ* if a *Thread* latency is higher than the
>          argument in us.
>  
> +**-t**, **--trace** \[*file*]
> +
> +        Save the stopped trace to [*file|osnoise_trace.txt*].
> +

The move also allow us to fix this: s/osnoise/timerlat/ ^^^^

It is an error at the man page.

-- Daniel

