Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A150C73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 171182171F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="ifNuv9Sm";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="FDDy0mNb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGIN5X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 09:57:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbfGIN5X (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 09:57:23 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69DtNoi022872;
        Tue, 9 Jul 2019 06:56:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=G5VjWCCtjdEnySWs2qs9MxTfqYJ3feBx5SRszABcQZE=;
 b=ifNuv9SmJjiVwXxcc4OxgU9679JwETsa3n2QZtDOFyDrPoADcmpeEeEgpWTTfkKwbNXr
 +IvdTKK3raG9gIlG75r0djrruxcOvz7i7feyG0eBJe4pyxzKIQkJtd8k/f9MsXK96emU
 szOs98ptDvK56DUoCWNVFEd9e2SyfByiozU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tmebu2dv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 06:56:53 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 9 Jul 2019 06:56:52 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 9 Jul 2019 06:56:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5VjWCCtjdEnySWs2qs9MxTfqYJ3feBx5SRszABcQZE=;
 b=FDDy0mNbf5NZYuD0dVKqE4l7a1Br+cJn/rq2VWV698ZRNb9iIUUPR+KnBPWzQrVxE4S1kWrX4t8K4G7qPfTwMNQoZL/rQNHMk8RbHC6npmGuny0SnnGRI/XvePqRd8e/j5xMK8qyEGt40ma91IKaEjyAHt7cIoti6XI054rbgU0=
Received: from BN6PR15MB1380.namprd15.prod.outlook.com (10.172.151.150) by
 BN6PR15MB1250.namprd15.prod.outlook.com (10.172.205.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 13:56:49 +0000
Received: from BN6PR15MB1380.namprd15.prod.outlook.com
 ([fe80::f426:9b2b:dbbf:dcaa]) by BN6PR15MB1380.namprd15.prod.outlook.com
 ([fe80::f426:9b2b:dbbf:dcaa%11]) with mapi id 15.20.2052.019; Tue, 9 Jul 2019
 13:56:49 +0000
From:   Josef Bacik <jbacik@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 04/11] trace-cmd: add global functions for live tracing
Thread-Topic: [PATCH 04/11] trace-cmd: add global functions for live tracing
Thread-Index: AQHVNleOuLpgwbsJSEOYB0Yq9lXov6bCT5/q
Date:   Tue, 9 Jul 2019 13:56:49 +0000
Message-ID: <0C57E3DE-5CA6-4958-B1B7-A19E5F95C7C6@fb.com>
References: <1448053053-24188-1-git-send-email-jbacik@fb.com>
        <1448053053-24188-5-git-send-email-jbacik@fb.com>,<20190709090917.7705c1da@gandalf.local.home>
In-Reply-To: <20190709090917.7705c1da@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:387:2:811::16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8dca52c5-39a2-4d1a-63c6-08d7047549f1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR15MB1250;
x-ms-traffictypediagnostic: BN6PR15MB1250:
x-microsoft-antispam-prvs: <BN6PR15MB12504766FAFF6AA07C51B497B9F10@BN6PR15MB1250.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(136003)(39860400002)(376002)(189003)(199004)(9886003)(86362001)(8936002)(68736007)(5024004)(14444005)(256004)(73956011)(229853002)(66946007)(76116006)(25786009)(66476007)(66556008)(64756008)(66446008)(6486002)(76176011)(305945005)(478600001)(316002)(7736002)(6246003)(6116002)(6506007)(5660300002)(53546011)(54906003)(102836004)(6512007)(2616005)(33656002)(486006)(6436002)(476003)(11346002)(71200400001)(8676002)(2906002)(71190400001)(186003)(46003)(81166006)(6916009)(81156014)(14454004)(99286004)(446003)(36756003)(4326008)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1250;H:BN6PR15MB1380.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LMpIksfRiQqUwzuKOhZo44Te7hd9SlQkVHxrkKv09Z/ozFx6Wgd+mA4AmRX9HnvltuN9FN44+PwzzfE9ATxa1x+EkaKfjT0hRBcNX3Zf+JNE/3Fuy9kqBLMChZHWMWe+dKBDIxx7EcOpdXNHWfd3Uv2ln54AkydcihfIKLcaEmbZFCITnlo0NxNOtlUpCsMrYyqYP4D8d6QG5fjkTUgx/UFyka4gsz1QbAJwGPyrBJyTDPDt+6E3V3RNRd71idT1le24vkub0rQhAtctxh2/Fj/E0uQg6gjzERFUl3drQhWhh2nkjgbDySDo1TyiHd1YQL4IIdzsGnWQbw3wPKfdbFz3H1cud1mU7jcnBwpCHUKAYIo5Kthw3iGJVGIw3bGnq3y8NOSUvegjEWTFe5cnwi7B7UTiReMeJgd/13P8dCE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dca52c5-39a2-4d1a-63c6-08d7047549f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 13:56:49.1726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbacik@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1250
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090166
X-FB-Internal: deliver
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yup go for it, thanks,

Josef

Sent from my iPhone

> On Jul 9, 2019, at 9:09 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Fri, 20 Nov 2015 15:57:26 -0500
> Josef Bacik <jbacik@fb.com> wrote:
>=20
>> We need a few functions to disable/enable tracing as well as add events =
to be
>> enabled on the first instance, this patch turns a couple of these local
>> functions into library functions.  Thanks,
>=20
> Hi Josef,
>=20
> Not sure you still use this, as it's not really a library function
> anymore. But we are currently cleaning up the trace-cmd code to create
> a real library, and doing it in baby steps. The
> tracecmd_enable_events() function is causing some issues and it was
> added by you. Are you OK if we remove it. At least temporarily until we
> separate out the "enabling" part into the library?
>=20
> Thanks!
>=20
> -- Steve
>=20
>=20
>>=20
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>> trace-cmd.h    |  5 +++++
>> trace-record.c | 45 +++++++++++++++++++++++++++------------------
>> 2 files changed, 32 insertions(+), 18 deletions(-)
>>=20
>> diff --git a/trace-cmd.h b/trace-cmd.h
>> index b4fa7fd..9a9ca30 100644
>> --- a/trace-cmd.h
>> +++ b/trace-cmd.h
>> @@ -268,6 +268,11 @@ int tracecmd_start_recording(struct tracecmd_record=
er *recorder, unsigned long s
>> void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
>> void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
>> long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
>> +int tracecmd_add_event(const char *event_str, int stack);
>> +void tracecmd_enable_events(void);
>> +void tracecmd_disable_all_tracing(int disable_tracer);
>> +void tracecmd_disable_tracing(void);
>> +void tracecmd_enable_tracing(void);
>>=20
>> /* --- Plugin handling --- */
>> extern struct pevent_plugin_option trace_ftrace_options[];
>> diff --git a/trace-record.c b/trace-record.c
>> index 417b701..7c471ab 100644
>> --- a/trace-record.c
>> +++ b/trace-record.c
>> @@ -841,7 +841,6 @@ static void update_ftrace_pids(int reset)
>>=20
>> static void update_event_filters(struct buffer_instance *instance);
>> static void update_pid_event_filters(struct buffer_instance *instance);
>> -static void enable_tracing(void);
>>=20
>> /**
>>  * make_pid_filter - create a filter string to all pids against @field
>> @@ -1106,7 +1105,7 @@ static void run_cmd(enum trace_type type, int argc=
, char **argv)
>>    if (!pid) {
>>        /* child */
>>        update_task_filter();
>> -        enable_tracing();
>> +        tracecmd_enable_tracing();
>>        enable_ptrace();
>>        /*
>>         * If we are using stderr for stdout, switch
>> @@ -1795,7 +1794,7 @@ static int read_tracing_on(struct buffer_instance =
*instance)
>>    return ret;
>> }
>>=20
>> -static void enable_tracing(void)
>> +void tracecmd_enable_tracing(void)
>> {
>>    struct buffer_instance *instance;
>>=20
>> @@ -1808,7 +1807,7 @@ static void enable_tracing(void)
>>        reset_max_latency();
>> }
>>=20
>> -static void disable_tracing(void)
>> +void tracecmd_disable_tracing(void)
>> {
>>    struct buffer_instance *instance;
>>=20
>> @@ -1816,9 +1815,9 @@ static void disable_tracing(void)
>>        write_tracing_on(instance, 0);
>> }
>>=20
>> -static void disable_all(int disable_tracer)
>> +void tracecmd_disable_all_tracing(int disable_tracer)
>> {
>> -    disable_tracing();
>> +    tracecmd_disable_tracing();
>>=20
>>    if (disable_tracer) {
>>        disable_func_stack_trace();
>> @@ -1991,6 +1990,11 @@ static void enable_events(struct buffer_instance =
*instance)
>>    }
>> }
>>=20
>> +void tracecmd_enable_events(void)
>> +{
>> +    enable_events(first_instance);
>> +}
>> +
>> static void set_clock(struct buffer_instance *instance)
>> {
>>    char *path;
>> @@ -3074,15 +3078,15 @@ static char *get_date_to_ts(void)
>>    }
>>=20
>>    for (i =3D 0; i < date2ts_tries; i++) {
>> -        disable_tracing();
>> +        tracecmd_disable_tracing();
>>        clear_trace();
>> -        enable_tracing();
>> +        tracecmd_enable_tracing();
>>=20
>>        gettimeofday(&start, NULL);
>>        write(tfd, STAMP, 5);
>>        gettimeofday(&end, NULL);
>>=20
>> -        disable_tracing();
>> +        tracecmd_disable_tracing();
>>        ts =3D find_time_stamp(pevent);
>>        if (!ts)
>>            continue;
>> @@ -3699,6 +3703,11 @@ profile_add_event(struct buffer_instance *instanc=
e, const char *event_str, int s
>>    return 0;
>> }
>>=20
>> +int tracecmd_add_event(const char *event_str, int stack)
>> +{
>> +    return profile_add_event(first_instance, event_str, stack);
>> +}
>> +
>> static void enable_profile(struct buffer_instance *instance)
>> {
>>    int stacktrace =3D 0;
>> @@ -3891,7 +3900,7 @@ void trace_record (int argc, char **argv)
>>=20
>>        }
>>        update_first_instance(instance, topt);
>> -        disable_tracing();
>> +        tracecmd_disable_tracing();
>>        exit(0);
>>    } else if (strcmp(argv[1], "restart") =3D=3D 0) {
>>        for (;;) {
>> @@ -3922,7 +3931,7 @@ void trace_record (int argc, char **argv)
>>=20
>>        }
>>        update_first_instance(instance, topt);
>> -        enable_tracing();
>> +        tracecmd_enable_tracing();
>>        exit(0);
>>    } else if (strcmp(argv[1], "reset") =3D=3D 0) {
>>        /* if last arg is -a, then -b and -d apply to all instances */
>> @@ -3984,7 +3993,7 @@ void trace_record (int argc, char **argv)
>>            }
>>        }
>>        update_first_instance(instance, topt);
>> -        disable_all(1);
>> +        tracecmd_disable_all_tracing(1);
>>        set_buffer_size();
>>        clear_filters();
>>        clear_triggers();
>> @@ -4314,7 +4323,7 @@ void trace_record (int argc, char **argv)
>>=20
>>    if (!extract) {
>>        fset =3D set_ftrace(!disable, total_disable);
>> -        disable_all(1);
>> +        tracecmd_disable_all_tracing(1);
>>=20
>>        for_all_instances(instance)
>>            set_clock(instance);
>> @@ -4365,7 +4374,7 @@ void trace_record (int argc, char **argv)
>>    } else {
>>        if (!(type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM))) {
>>            update_task_filter();
>> -            enable_tracing();
>> +            tracecmd_enable_tracing();
>>            exit(0);
>>        }
>>=20
>> @@ -4373,7 +4382,7 @@ void trace_record (int argc, char **argv)
>>            run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
>>        else {
>>            update_task_filter();
>> -            enable_tracing();
>> +            tracecmd_enable_tracing();
>>            /* We don't ptrace ourself */
>>            if (do_ptrace && filter_pid >=3D 0)
>>                ptrace_attach(filter_pid);
>> @@ -4383,7 +4392,7 @@ void trace_record (int argc, char **argv)
>>                trace_or_sleep(type);
>>        }
>>=20
>> -        disable_tracing();
>> +        tracecmd_disable_tracing();
>>        if (!latency)
>>            stop_threads(type);
>>    }
>> @@ -4391,7 +4400,7 @@ void trace_record (int argc, char **argv)
>>    record_stats();
>>=20
>>    if (!keep)
>> -        disable_all(0);
>> +        tracecmd_disable_all_tracing(0);
>>=20
>>    /* extract records the date after extraction */
>>    if (extract && date) {
>> @@ -4399,7 +4408,7 @@ void trace_record (int argc, char **argv)
>>         * We need to start tracing, don't let other traces
>>         * screw with our trace_marker.
>>         */
>> -        disable_all(1);
>> +        tracecmd_disable_all_tracing(1);
>>        date2ts =3D get_date_to_ts();
>>    }
>>=20
>=20
