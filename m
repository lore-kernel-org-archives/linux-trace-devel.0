Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7697C1A4E70
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754317737; cv=none; b=Ndf9xfB+Uvi7aW4DrrtsTYrjm1hihYe4c0ZvOwtkeQaDsqsOx1LoA0QEdrvh/uFJzTFtlkdZZ9JprL2ssRfkJhGm5UGALnSMVoIw/+ITs4S83MjSHTJHLM+tGEQ2n7XEWx+nZ0ZaUtzfoF1w3WtB+4dL3bu/CGG2UEXo8Zad2QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754317737; c=relaxed/simple;
	bh=YJpNTtu8ZQIZq29fYxqJMXfyhxr4msNA8M4xegM6mxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PEqRbH85qcbY755/Eb9B653QiLdViu/cdB3YPJKJq6cz6ekYMvb/2nMO1SMy2FyvGsg7VgmFeb4vqbUgFUEs/zpATAjY5ovUjp76whtpwNCeolzLsIW8h8+dTAzv/6EXlI9BG107DedsyujFmqxE5ocQ1iQ8gnMSlyGhaX3OrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82272150C;
	Mon,  4 Aug 2025 07:28:47 -0700 (PDT)
Received: from [192.168.1.127] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B12B53F738;
	Mon,  4 Aug 2025 07:28:53 -0700 (PDT)
Message-ID: <8e75d9d2-8fa2-4232-a00e-2e9bc20d3701@arm.com>
Date: Mon, 4 Aug 2025 15:28:58 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] trace-cmd: Use BTF to parse function arguments
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Takaya Saeki <takayas@google.com>, Ian Rogers <irogers@google.com>,
 aahringo@redhat.com
References: <20250731202238.1654368-1-rostedt@goodmis.org>
 <6457bff9-9485-4d2d-82a5-ae436932000a@arm.com>
 <20250804084543.61c4d6c7@gandalf.local.home>
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20250804084543.61c4d6c7@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04-08-2025 13:45, Steven Rostedt wrote:
> On Mon, 4 Aug 2025 13:36:26 +0100
> Douglas Raillard <douglas.raillard@arm.com> wrote:
> 
>> On 31-07-2025 21:20, Steven Rostedt wrote:
>>> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>>>
>>> If function tracer is recorded with func-args option set, or the
>>> function_graph tracer is recorded with the funcgraph-args option set, then
>>> record the BTF file in a new BTF_FILE section in the trace.dat file.
>>
>> Would it be possible to also add an explicit CLI flag to collect the BTF blob ?
> 
> Sure, that shouldn't be to hard. We could add --btf /path/to/file  for both
> the record and the report.

Sounds like a good idea. If you want to support passing BTF at report time to supplement a BTF-less trace.dat,
it would make sense to also support getting BTF from the ELF section so that people can pass the real
vmlinux file directly (not the BTF blob in sysfs, the actual ELF vmlinux from Kbuild).

It seems libbpf allows to do that with bpf_object__open_file():
https://docs.ebpf.io/ebpf-library/libbpf/userspace/bpf_object__open_file/


> -- Steve

-- 
Douglas
