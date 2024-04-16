Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80646130A57;
	Tue, 16 Apr 2024 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713278938; cv=none; b=mhCdrZF5bIx2IGVixWub4Vy1VmP6vJH7nxeXHQ4eKxUGngHiXZzYQLAyBo/oGoaMr1i7rZV7/dmvqMRixITEybEnHhgeddNlgf7Xiedwb9675hSsllVXDZqqOS/RCOn9NbcMedxXJOYmy8FCZpWnXrspeBExnWj/wSho9KCmSfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713278938; c=relaxed/simple;
	bh=XASMDrMQqjDqU0d0fbKxtJY6C1GYjAaFpOo2re1urus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OEWER7z8K+DuUY+nt0zG81Nxr2me8YNvJnas3jJdDmL1Z/GiwhPg1IWn7fzEQilcrrNS9zsDa4QSyq60lOk0ptfFb7hL0Ut8dy0BjvFx46ANSp1XUpj13hv8dQH2G5hckOzXhUAArbSVMWfRytZS+LL9nSintOyn3wHW4AZ2xUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=myYs6w9+; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="myYs6w9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1713278935;
	bh=XASMDrMQqjDqU0d0fbKxtJY6C1GYjAaFpOo2re1urus=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=myYs6w9+hwAIAfwbR6flzjGY65R7Gnln+E8J77MNplcUCk0+vGNs5COWL1pszRVtk
	 Il8WwjodaoIM+D92vBnQX9s+/ILu1PSIdXABIR9HQvCdLQPWDbcR7a29oHRYpS8+lb
	 RW3JmvRBtn5BO5NkkRRQEaEIUV0Gs75TTAqhwFBQ1EGC0DNR0RkZnVzEthzjFLMTfU
	 X+PfalRiHJMN3LNuu+4CB74DSnSotC3dkxzteQWM2jbxDWSbDcj0VZOkPMTxhbaYcH
	 t1S8D1nBgELojLS6RqsctbxLck/UJx82L15JESRj/d9J2xWb87/YMXJrNZmYxa5awR
	 J9L2ghGANhTHg==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4VJn3q2xw3zw7j;
	Tue, 16 Apr 2024 10:48:55 -0400 (EDT)
Message-ID: <46859f90-bdf6-4502-bf6a-4add6dad3668@efficios.com>
Date: Tue, 16 Apr 2024 10:48:57 -0400
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: using NIC DMA ring as tracing buffer?
To: Alexander Aring <aahringo@redhat.com>, linux-trace-devel@vger.kernel.org
Cc: linux-trace-users@vger.kernel.org
References: <CAK-6q+iAuLM35C1kZbDpS4E_61vC9A1mTpJb+nzhfX5DPUQkGg@mail.gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <CAK-6q+iAuLM35C1kZbDpS4E_61vC9A1mTpJb+nzhfX5DPUQkGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-04-16 10:41, Alexander Aring wrote:
> Hi all,
> 
> I have an idea about using the DMA rings of a networking card as a
> tracing buffer. 

The first thing I'd be worried about is overhead caused by
false-sharing if you trace a large SMP/many-core system all
into the same global NIC buffer. The cache lines will bounce
left and right which is bad performance-wise.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

