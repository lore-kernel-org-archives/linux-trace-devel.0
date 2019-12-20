Return-Path: <SRS0=9eMf=2K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFEBC43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 07:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A4024680
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 07:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfLTHcs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:32:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbfLTHcr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 02:32:47 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBK7U7WV031771
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Dec 2019 02:32:46 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x0pn7yby5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Dec 2019 02:32:46 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-trace-devel@vger.kernel.org> from <svens@linux.ibm.com>;
        Fri, 20 Dec 2019 07:32:44 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Dec 2019 07:32:42 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBK7WfvA57147616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Dec 2019 07:32:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E3D7A4067;
        Fri, 20 Dec 2019 07:32:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF294A405F;
        Fri, 20 Dec 2019 07:32:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 20 Dec 2019 07:32:40 +0000 (GMT)
Date:   Fri, 20 Dec 2019 08:32:40 +0100
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Shuah Khan <shuahkhan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] selftests/ftrace: fix glob selftest
References: <20191218074427.96184-1-svens@linux.ibm.com>
 <20191218074427.96184-2-svens@linux.ibm.com>
 <20191219183151.58d81624@gandalf.local.home>
 <20191220162746.d0889aeac721f8e4d400db64@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220162746.d0889aeac721f8e4d400db64@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-TM-AS-GCONF: 00
x-cbid: 19122007-0028-0000-0000-000003CA86B7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19122007-0029-0000-0000-0000248DDA63
Message-Id: <20191220073240.GA72310@tuxmaker.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_08:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912200059
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Fri, Dec 20, 2019 at 04:27:46PM +0900, Masami Hiramatsu wrote:
> On Thu, 19 Dec 2019 18:31:51 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 18 Dec 2019 08:44:25 +0100
> > Sven Schnelle <svens@linux.ibm.com> wrote:
> > 
> > > test.d/ftrace/func-filter-glob.tc is failing on s390 because it has
> > > ARCH_INLINE_SPIN_LOCK and friends set to 'y'. So the usual
> > > __raw_spin_lock symbol isn't in the ftrace function list. Change
> > > '*aw*lock' to '*time*ns' which would hopefully match some of the
> > > ktime_() functions on all platforms.
> > 
> > This requires an ack from Masami, and this patch can go through Shuah's
> > tree.
> > 
> > Also, any patches for the Linux kernel should be Cc'd to lkml. The
> > linux-trace-devel is mostly for tracing tools, not kernel patches.
> 
> Thanks Steve to CC to me.
> BTW, are there any reason why we use different symbols for different
> glob patterns?
> I mean we can use 'schedul*', '*chedule' and '*sch*ule' as test
> glob patterns.

Don't know, but i don't see a reason why we should have different patterns. If
there's an agreement that we prefer a common pattern i can update the patch and
resend.

Regards
Sven

