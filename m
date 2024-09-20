Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D672231C
	for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2024 09:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726825699; cv=none; b=iDfK5z4PecSzCJrsMqUKNCAbDWOiZWUfgHa5Kq7bf+FM1IOy0dO17xXwGSXL+g6vUzFy1MiZ0Lp8U8wEuAJYIVuNPKMK1oMtj8CIwLFGxDOR+26VSsncu5VSDLFan8M6komemddbvXgtKtA+n2Q+mfPZCo8proAPCaST/R+FEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726825699; c=relaxed/simple;
	bh=tLuWzAUKt6Uefu+LLA9WObuniRca7SP4Czof/peQSX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0HLGrMYHht0hFIOygOK+0/rQh+j1vRsaOhHVSJ6MtLEZsjc1orX+ENESo5RIcPE3/4Lcqc0mDrURgq0Mq4qMJSJHsT6zR2KzGlBdYv/Ka3r3YwyOJMieFD4HbHOvjVxo0ODTmjBQznMauaglYPQLOGRdBrAkcWeyAPoxPTkNlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C5B51007;
	Fri, 20 Sep 2024 02:48:46 -0700 (PDT)
Received: from [192.168.89.238] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64D003F66E;
	Fri, 20 Sep 2024 02:48:15 -0700 (PDT)
Message-ID: <2e974688-482e-4144-ba07-efe6a483f304@arm.com>
Date: Fri, 20 Sep 2024 10:48:14 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: libtraceevent + Rust
To: Hidenori Kobayashi <hidenorik@chromium.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
 rostedt@goodmis.org, Nikita Baksalyar <nikita.baksalyar@gmail.com>
References: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
 <20230213051727.hvkd5wgqhxi66gqh@google.com>
 <35fe67d1-0865-486f-bdbe-5eb8e034352d@arm.com>
 <20230214035657.4nz5tyirzfmvcxuq@google.com>
 <2c1381a6-164d-fc5c-fd69-653d69604c50@arm.com>
 <20230215003656.myopnnfdgmmck7dg@google.com>
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20230215003656.myopnnfdgmmck7dg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Hidenori,

On 15-02-2023 00:36, Hidenori Kobayashi wrote:

> Looking forward to the upcoming announcement!

I've just sent it to trace-devel if you are still interested in these matters.

Thanks,

Douglas
