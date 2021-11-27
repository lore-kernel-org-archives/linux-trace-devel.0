Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3761C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhK0PPQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 27 Nov 2021 10:15:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:48831 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237441AbhK0PNM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 27 Nov 2021 10:13:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="234496785"
X-IronPort-AV: E=Sophos;i="5.87,269,1631602800"; 
   d="scan'208";a="234496785"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 07:09:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,269,1631602800"; 
   d="scan'208";a="457956801"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 27 Nov 2021 07:09:55 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mqzKs-0009fo-0D; Sat, 27 Nov 2021 15:09:54 +0000
Date:   Sat, 27 Nov 2021 23:09:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Beau Belgrave <beaub@linux.microsoft.com>, rostedt@goodmis.org,
        mhiramat@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: Re: [PATCH v5 09/12] user_events: Optimize writing events by only
 copying data once
Message-ID: <202111272346.r2ZhQ5KM-lkp@intel.com>
References: <20211116005047.1808-10-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116005047.1808-10-beaub@linux.microsoft.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Beau,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 67d4f6e3bf5dddced226fbf19704cdbbb0c98847]

url:    https://github.com/0day-ci/linux/commits/Beau-Belgrave/user_events-Enable-user-processes-to-create-and-write-to-trace-events/20211116-090533
base:   67d4f6e3bf5dddced226fbf19704cdbbb0c98847
config: hexagon-randconfig-r031-20211116 (https://download.01.org/0day-ci/archive/20211127/202111272346.r2ZhQ5KM-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project fbe72e41b99dc7994daac300d208a955be3e4a0a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5d08d02e133130c59d164c17756a0aa0abb5418c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Beau-Belgrave/user_events-Enable-user-processes-to-create-and-write-to-trace-events/20211116-090533
        git checkout 5d08d02e133130c59d164c17756a0aa0abb5418c
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/gpio/ kernel/trace/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> kernel/trace/trace_events_user.c:563:22: warning: comparison of distinct pointer types ('typeof (i->count) *' (aka 'unsigned int *') and 'typeof ((1UL << 16)) *' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
                   size_t copy_size = min(i->count, MAX_BPF_COPY_SIZE);
                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:45:19: note: expanded from macro 'min'
   #define min(x, y)       __careful_cmp(x, y, <)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   1 warning generated.


vim +563 kernel/trace/trace_events_user.c

   537	
   538	#ifdef CONFIG_PERF_EVENTS
   539	static void user_event_bpf(struct user_event *user, struct iov_iter *i)
   540	{
   541		struct user_bpf_context context;
   542		struct user_bpf_iter bpf_i;
   543		char fast_data[MAX_STACK_BPF_DATA];
   544		void *temp = NULL;
   545	
   546		if ((user->flags & FLAG_BPF_ITER) && iter_is_iovec(i)) {
   547			/* Raw iterator */
   548			context.data_type = USER_BPF_DATA_ITER;
   549			context.data_len = i->count;
   550			context.iter = &bpf_i;
   551	
   552			bpf_i.iov_offset = i->iov_offset;
   553			bpf_i.iov = i->iov;
   554			bpf_i.nr_segs = i->nr_segs;
   555		} else if (i->nr_segs == 1 && iter_is_iovec(i)) {
   556			/* Single buffer from user */
   557			context.data_type = USER_BPF_DATA_USER;
   558			context.data_len = i->count;
   559			context.udata = i->iov->iov_base + i->iov_offset;
   560		} else {
   561			/* Multi buffer from user */
   562			struct iov_iter copy = *i;
 > 563			size_t copy_size = min(i->count, MAX_BPF_COPY_SIZE);
   564	
   565			context.data_type = USER_BPF_DATA_KERNEL;
   566			context.kdata = fast_data;
   567	
   568			if (unlikely(copy_size > sizeof(fast_data))) {
   569				temp = kmalloc(copy_size, GFP_NOWAIT);
   570	
   571				if (temp)
   572					context.kdata = temp;
   573				else
   574					copy_size = sizeof(fast_data);
   575			}
   576	
   577			context.data_len = copy_nofault(context.kdata,
   578							copy_size, &copy);
   579		}
   580	
   581		trace_call_bpf(&user->call, &context);
   582	
   583		kfree(temp);
   584	}
   585	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
