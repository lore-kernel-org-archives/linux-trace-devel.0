Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2DC23909F
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762964419; cv=none; b=DUtrG44AwZeemjxOY90BgP6YDggfIAwRfFnljRwbsFSgFKFvTI0+5SPrlp/IIyRnLcG6zWELV0wIGldYzozgq/yF6t6FGcp2TTDqJVdloYmFeeTJOT1R6XmBD5JuDXobdukdQOBTvxxZhDg4ZNhS/64jXUgLnkcfNmL2A112sRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762964419; c=relaxed/simple;
	bh=iGGgCCy1NLJ8OybqguT74kMCDTED2Davo2WjcPgE0hY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M2m5B+U39e500N/T5XvE0XAORbvg6Ph5Svi0PErLGq90eJxDCQz99PmZ929sNxtCFOKX4CikD+A8nsd1X+f8VqG1dRgWa4s6B8dCGqK+JIlu4mc84HwysLl3lLYBUqnc4jZP7PNaDH3gPSh/Zds6Ezx1DgBWHry9GLHIh/s4eYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34417497;
	Wed, 12 Nov 2025 08:20:09 -0800 (PST)
Received: from [10.57.74.11] (unknown [10.57.74.11])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 682AC3F63F;
	Wed, 12 Nov 2025 08:20:16 -0800 (PST)
Message-ID: <494a7e7f-6878-471f-a69a-f418ef140305@arm.com>
Date: Wed, 12 Nov 2025 16:19:54 +0000
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] libtraceevent: Fix static library to hide hidden
 functions
To: Steven Rostedt <rostedt@goodmis.org>, linux-trace-devel@vger.kernel.org
Cc: Douglas Raillard <douglas.raillard@arm.com>
References: <20251112144912.268258-1-rostedt@goodmis.org>
Content-Language: en-US
From: Metin Kaya <metin.kaya@arm.com>
In-Reply-To: <20251112144912.268258-1-rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/2025 2:45 pm, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> When the static library uses the objects directly to be created, it makes
> all the hidden functions visible to applications that link to it.
> 
> To fix this, create a helper function in the Makefile (redefine_local) that
> will search for all the global functions within the shared library, and if
> they do not start with "tep_", they are renamed to start with "_tep_local_".
> This will keep these function from colliding with the namespace of
> applications that may link to the static library.
> 
> Changes since v1: https://lore.kernel.org/all/20250814144710.6c3458d4@gandalf.local.home/
> 
> - Instead of playing tricks to what to add to the static library, just
>    change the static library directly.
> 
> - Modified the meson build to have this as well.
> 
> Steven Rostedt (Google) (2):
>    libtraceevent: Have static library to hide hidden functions
>    libtraceevent: Have meson build rename hidden global functions
> 
>   Makefile.meson          |  15 +-
>   scripts/utils.mk        |   5 +
>   src/Makefile            |   8 +-
>   src/event-parse-api.c   |   6 +-
>   src/event-parse-local.h |  24 ++--
>   src/event-parse.c       | 298 ++++++++++++++++++++--------------------
>   src/event-plugin.c      |   2 +-
>   src/parse-filter.c      |  22 +--
>   8 files changed, 200 insertions(+), 180 deletions(-)
> 

Tested the changes on my Ubuntu-25.04 (6.14.0-34-generic x86_64) with 
HEAD of libtraceevent, libtracefs and trace-cmd.

Could build trace-cmd statically. Did not see any regressions in unit 
tests. Basic smoke test (e.g., trace-cmd record/report) looks fine.

You can have my:

Tested-by: Metin Kaya <metin.kaya@arm.com>
Reviewed-by: Metin Kaya <metin.kaya@arm.com>

Thanks,
