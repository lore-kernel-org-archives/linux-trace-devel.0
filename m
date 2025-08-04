Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FE12475CF
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 11:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754305750; cv=none; b=qfeWV+eTxmpDndjWom/LR0EWnubCt8rBcx2mI2SVKPjKjpj4c0v9V7VvqxbXpPtSiE50urye0O77BcEdVde+shjtIrxhAB3GSWbBxm9MAiowuv4x80mCrr49OhV/21YaR/XbPaPuLQmzHPM0KD8n88hLgIEDPui723AQSsQ6jGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754305750; c=relaxed/simple;
	bh=il1O6voPQQW44l+eFmULx9YRFchkhsr5fHApiO8lsJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OLf8BFTJVxza32q+OjFs4GcOaTds7Q2xDX6JIXuhA/L4IoWZztSynesLVh+K31OX71kYP8rjkjkZ6vXG4yuub3iyB6kFk37/gyacmS53LM7z63928bq3nLffr7OGP929w8HJKNmA1CdHECgTduAfE6o2kbj7hHHwZC3884Nb+zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD9F51C25;
	Mon,  4 Aug 2025 04:08:58 -0700 (PDT)
Received: from [192.168.1.127] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 536513F673;
	Mon,  4 Aug 2025 04:09:05 -0700 (PDT)
Message-ID: <ce2ded58-79d5-4cdd-87ef-e6aa6613425b@arm.com>
Date: Mon, 4 Aug 2025 12:09:09 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] libtraceevent: Add man page for the new BTF functions
To: Steven Rostedt <rostedt@goodmis.org>, linux-trace-devel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Takaya Saeki <takayas@google.com>,
 Ian Rogers <irogers@google.com>, aahringo@redhat.com
References: <20250731185559.1644753-1-rostedt@goodmis.org>
 <20250731185559.1644753-3-rostedt@goodmis.org>
Content-Language: en-US
From: Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20250731185559.1644753-3-rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31-07-2025 19:52, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add a man page for tep_load_btf() and tep_btf_print_args()
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   Documentation/libtraceevent-btf.txt | 158 ++++++++++++++++++++++++++++
>   Documentation/libtraceevent.txt     |   5 +
>   2 files changed, 163 insertions(+)
>   create mode 100644 Documentation/libtraceevent-btf.txt
> 
> diff --git a/Documentation/libtraceevent-btf.txt b/Documentation/libtraceevent-btf.txt
> new file mode 100644
> index 000000000000..802d953a6ef1
> --- /dev/null
> +++ b/Documentation/libtraceevent-btf.txt
> @@ -0,0 +1,158 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_load_btf, tep_btf_print_args -
> +Load BTF file and use it to pretty print function arguments.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_load_btf*(struct tep_handle pass:[*]_tep_, void pass:[*]_raw_data_, size_t _data_size_);
> +int *tep_btf_print_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, void pass:[*]_args_,
> +		       int nmem, int size, const char pass:[*]_func_);
> +--
> +
> +DESCRIPTION
> +-----------
> +If the Linux kernel has BTF configured, then a binary file will exist
> +in the path of */sys/kernel/btf/vmlinux*. If this file is read into memory
> +and passed to *tep_load_btf()* function, then it will be used to parse
> +the arguments of a given function, if that function data is found within
> +the BTF file.
> +
> +The *tep_load_btf()* takes the _tep_ handle and will load the allocated _raw_data_
> +into it. NOTE, the _raw_data_ must be allocated via glibc() allocations as on
> +success, it will save the _raw_data_ internally, and will be freed when the
> +_tep_ handler is destroyed. If it is called twice, it will free the old _raw_data_
> +and reinitialize itself with the new _raw_data_. The _data_size_ should be set
> +to the size of the content in _raw_data_.
> +
> +The *tep_btf_print_args()* takes a _tep_ handle, a trace_seq _s_ pointer
> +(that was initialized by *trace_seq_init(3)*), an _args_ array that holds either
> +4 byte or 8 byte values, the _nmem_ that is the number of values in the _args_
> +parameter, a _size_ that is either 4 or 8 to denote the size of each value in _args_,
> +and a _func_ string that is the name of the function to find the BTF information
> +to use for parsing. If BTF is not loaded or the _func_ name is not found it
> +will just print a hex value of all the _args_ into the _s_ descriptor.

For clarity, it may be best to not call those things "args", as they may well not be args.
Before BTF is used to decode, this is merely the values of a bunch of registers assumed to
hold arguments value, with an unknown mapping of register value to actual args. For example,
both square() and square_struct() map the exact same assembly on arm64, clang 20 (tested with godbolt):

   struct nums {
       unsigned long num1;
       unsigned long num2;
   };
   
   unsigned long square(unsigned long num1, unsigned long num2) {
       return num1 * num2;
   }
   
   unsigned long square_struct(struct nums nums) {
       return nums.num2 * nums.num1;
   }
   
   
   square:
           mul     x0, x1, x0
           ret
   
   square_struct:
           mul     x0, x1, x0
           ret
   

If "int" is used instead of "unsigned long", you get an even more interesting non-1-1 mapping
where a single register is used to hold both 32 bit values, but only when the struct parameter
is used:

   square_struct:
           lsr     x8, x0, #32
           mul     w0, w8, w0
           ret

So there can be more arguments than register used, and also less arguments than register used.


On a somewhat related note, I realized while experimenting that the equivalent function in Rust
does not necessarily comply with the same ABI:

   #[unsafe(no_mangle)]
   pub fn square(num1: u32, num2: u32) -> u32 {
       num1 * num2
   }
   
   struct Nums {
       num1: u32,
       num2: u32,
   }
   
   #[unsafe(no_mangle)]
   pub fn square_struct(nums: Nums) -> u32 {
       nums.num1 * nums.num2
   }
   
   square:
           mul     w0, w1, w0
           ret
   
   square_struct:
           mul     w0, w1, w0
           ret


So both those functions have the same ABI, unlike the C version where the struct version
packs both nums in a single 64 bits register. While I haven't checked the Rust/kernel BTF
support, BTF itself currently only encodes AST-level information (with a handful of exceptions)
and the Rust struct version would likely be encoded the same way as the C variant. And yet
they both have different ABIs ...

Since Rust ABI is not stable, you can't assume assume anything in general, but even pretty basic
things like that can still differ with the C version. Unfortunately, BTF does not encode the language
used for each function, so libtraceevent will have to be blind.

> +RETURN VALUE
> +------------
> +*tep_load_btf()* function returns 0 on success and the _raw_data_ is now
> +owned by the _tep_ descriptor and will be freed when it is destroyed.
> +It returns -1 on failure and the _raw_data_ will need to be freed by the caller.
> +
> +*tep_btf_print_args()* returns 0 on success and -1 on failure, which happens
> +if the _size_ is not valid or the BTF file that was loaded is corrupted.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +int print_args(const char *func, unsigned long *args, int nr)
> +{
> +	struct tep_handle *tep;
> +	struct trace_seq s;
> +	struct stat st;
> +	ssize_t r;
> +	size_t tot = 0;
> +	void *buf;
> +	int fd;
> +
> +	if (!tep)
> +		return -1;
> +
> +	fd = open("/sys/kernel/btf/vmlinux", O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	if (fstat(fd, &st) < 0) {
> +		close(fd);
> +		return -1;
> +	}
> +
> +	buf = malloc(st.st_size);
> +	if (!buf) {
> +		close(fd);
> +		return -1;
> +	}
> +
> +	while (tot < st.size) {
> +		r = read(fd, buf + tot, st.st_size - tot);
> +		if (r <= 0)
> +			break;
> +		tot += r;
> +	}
> +	close(fd);
> +
> +	tep = tep_alloc();
> +	if (!tep) {
> +		free(buf);
> +		return -1;
> +	}
> +
> +	if (tep_load_btf(tep, buf, tot) < 0) {
> +		free(buf);
> +		return -1;
> +	}
> +
> +	/* Now buf belongs to tep and does not need to be freed */
> +
> +	trace_seq_init(&s);
> +
> +	printf("%s(", func);
> +	tep_btf_print_args(tep, &s, args, nr, sizeof(long), func);
> +
> +	/* This will also free buf */
> +	tep_free(tep);
> +}
> +...
> +The above may output:
> +
> +  getname_flags(filename=0x7ffe7d33f3d0, flags=0)
> +
> +If BTF is loaded and the function was found, or it may show:
> +
> +  getname_flags(7ffe7d33f3d0, 0, 0, 0, 0, 0)
> +
> +If it was not.
> +...
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +*libtraceevent*(3), *trace-cmd*(1)
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
> diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
> index 9e7777283c52..5fb5fc19ffc1 100644
> --- a/Documentation/libtraceevent.txt
> +++ b/Documentation/libtraceevent.txt
> @@ -166,6 +166,11 @@ KVM plugin calllbacks: (Defined by the application and complied with -rdynamic)
>   				    unsigned long long pass:[*]paddr);
>   	void *tep_plugin_kvm_put_func*(const char pass:[*]func);
>   
> +BTF parsing:
> +	int *tep_load_btf*(struct tep_handle pass:[*]_tep_, void pass:[*]_raw_data_, size_t _data_size_);
> +	int *tep_btf_print_args*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, void pass:[*]_args_,
> +		       int nmem, int size, const char pass:[*]_func_);
> +
>   Trace sequences:
>   *#include <trace-seq.h>*
>   	void *trace_seq_init*(struct trace_seq pass:[*]_s_);


--

Douglas
