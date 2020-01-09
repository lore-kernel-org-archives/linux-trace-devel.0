Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8363C282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 13:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65820206ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 13:21:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=vmware.com header.i=@vmware.com header.b="GOJoNMwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgAINVx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 08:21:53 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:6212
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgAINVx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:21:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7exWXHqx5LTvguvCKfmMC66pYgPBsVuq7Ry6G1BXMeu8mBOfRbApvLX7oLYDMxQF9OFlMjWVdNwPlDBOZHlHB0rT7XqEWDjSVlE0MgMG4PVJEF6TbvYItLAwIrEhPiKlNF8FLS4/mwkNJyeEAPYvYd3CguGIs3ZPYrRM3feBNuijOp0sP7F7TSb/MO5XdLcrjoYRviLtO4BW8JD1/hzYNV+4emN/N39MOZ22ZHqCtf81BYKDFHDzRxot1ve6LRinnGAsnXiKzOhZ1742toNBD3cnoGyJZKzpt4oeCjTnVwqObULtBxFPsIVqQ66guQ/9Ktd7/Zn3I/CkOKCJlnLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVq8us5MY05fzgpWezZZVtdz3mDaV1TRTgJazD2MHoQ=;
 b=h+fXL9rZ7+yP3rIQF222PYVmXbNLLd98L/IRbvxm4aKjtqaqCKS4rHECDpd1eqHFqKOT0yqH56izzdJoIPYyBdPEDqi7FmPITJaqkmSEZL3O/ZsHmsgQxL+gGdZkrl2Nlm8qmUGh5Zp+EPzJuIEkGAeXoIOQchnZqpp5FaASuLGkN89DnYELdNPcAMMwpzkM6lNmOS8GfA96lJp429qLb66cg2+p/whtnHogGkwX5JuxT3+OJt8seihG72WTHo+PezDg8WPXFHprkCkxrIxG9hc0ND7ox+gjfvcss+sHSTmhMqZUynRv/wlu2ChLv/BgyQP8L7Sn95eIDIQwYTcLQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVq8us5MY05fzgpWezZZVtdz3mDaV1TRTgJazD2MHoQ=;
 b=GOJoNMwbpE9udxzuKFH3w/h+9DshG4h0ztxvAv4QRcxVAqSSIYMiEfNtE82vVXM4T7olKXbQMg1WBRkycAIBwdGDgWOQ3nM78CTUI9u9dAW4vKjhEnQ8mSGepV7s0uVIlCf6e2HYi/wekyKhKqHQsJe4gLgRWqoDDLQZN3hFwm4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tstoyanov@vmware.com; 
Received: from SN6PR05MB4045.namprd05.prod.outlook.com (52.135.66.139) by
 SN6PR05MB4190.namprd05.prod.outlook.com (52.132.124.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.7; Thu, 9 Jan 2020 13:21:49 +0000
Received: from SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::9962:8b24:37a2:6d18]) by SN6PR05MB4045.namprd05.prod.outlook.com
 ([fe80::9962:8b24:37a2:6d18%6]) with mapi id 15.20.2623.008; Thu, 9 Jan 2020
 13:21:49 +0000
X-Gm-Message-State: APjAAAWk2eCT4gfLp1qfDXhFWDyI5/58n/4K8Rcs8fdaS5badKNESI1y
        SxeW/BquvdxrKeePDHCSPgom45VdYBUFtMWuj3U=
X-Google-Smtp-Source: APXvYqx1o5bl5vYkjNmkkoJoeTVCFCWiHZ+jnKMj+C5h7To0c3H1yDHNTlPwy44rjpIenqX4isPNBFyQJFE43wxxegk=
X-Received: by 2002:adf:eb0a:: with SMTP id s10mr11550312wrn.320.1578576103862;
 Thu, 09 Jan 2020 05:21:43 -0800 (PST)
References: <20200106113026.75893f92@gandalf.local.home>
In-Reply-To: <20200106113026.75893f92@gandalf.local.home>
From:   "Tzvetomir (Ceco) Stoyanov" <tstoyanov@vmware.com>
Date:   Thu, 9 Jan 2020 15:21:32 +0200
X-Gmail-Original-Message-ID: <CACqStod9=8xta3QmdLX5BW+fmHL+ohS-ows0mWkRnt3KwxNp5w@mail.gmail.com>
Message-ID: <CACqStod9=8xta3QmdLX5BW+fmHL+ohS-ows0mWkRnt3KwxNp5w@mail.gmail.com>
Subject: Re: Ideals for tep plugin options
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: AM0PR02CA0014.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::27) To SN6PR05MB4045.namprd05.prod.outlook.com
 (2603:10b6:805:26::11)
MIME-Version: 1.0
Received: from mail-wr1-f49.google.com (209.85.221.49) by AM0PR02CA0014.eurprd02.prod.outlook.com (2603:10a6:208:3e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.16 via Frontend Transport; Thu, 9 Jan 2020 13:21:48 +0000
Received: by mail-wr1-f49.google.com with SMTP id d16so7332671wre.10        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 05:21:48 -0800 (PST)
X-Gm-Message-State: APjAAAWk2eCT4gfLp1qfDXhFWDyI5/58n/4K8Rcs8fdaS5badKNESI1y
        SxeW/BquvdxrKeePDHCSPgom45VdYBUFtMWuj3U=
X-Google-Smtp-Source: APXvYqx1o5bl5vYkjNmkkoJoeTVCFCWiHZ+jnKMj+C5h7To0c3H1yDHNTlPwy44rjpIenqX4isPNBFyQJFE43wxxegk=
X-Received: by 2002:adf:eb0a:: with SMTP id
 s10mr11550312wrn.320.1578576103862; Thu, 09 Jan 2020 05:21:43 -0800 (PST)
X-Gmail-Original-Message-ID: <CACqStod9=8xta3QmdLX5BW+fmHL+ohS-ows0mWkRnt3KwxNp5w@mail.gmail.com>
X-Originating-IP: [209.85.221.49]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 094ebd7e-c2db-4346-95e0-08d79506e18b
X-MS-TrafficTypeDiagnostic: SN6PR05MB4190:
X-Microsoft-Antispam-PRVS: <SN6PR05MB41905046C6C14498239CED4DDC390@SN6PR05MB4190.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 02778BF158
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(189003)(199004)(2906002)(4326008)(8936002)(5660300002)(26005)(9686003)(52116002)(66556008)(186003)(53546011)(478600001)(86362001)(55446002)(6666004)(66476007)(316002)(42186006)(8676002)(81166006)(81156014)(6862004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4190;H:SN6PR05MB4045.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9nnh3zVjJGykZxl/586Jmb7BWx98ji3KROLRBovmfAYYh+ocuomTfaRx+Kied0TOobGFdKjiZ+dEH9QV/dK9kB/cIlkai7UqRIalbOcN+S9hfVM76w3M20S6VLS5M1p+0FjEXSqo06lm2k08PyKYl3paKwRpqIaWqynq/V2WV+KPw+TycmI/1Tmhxx0uXZzaBOg+OpMcaOdXyycUnVxpGCwzN7PM/lIGdww5qi+F3Bg0lqm5vJQCnRQJCNFRoO1wOf9IQE01VZSafz26a+fmISnHXzIj02VAMpS+JErR5mjlez7Ursq1MPoviwAG8fGlF7K7s7FRpHwsrQe0bZCZloHCLMWvj5PNl/c5Dc3icjmrpw/vIoQ5QutJBd+jh8A7BSxkcMImBfaGbegNq+9OiQuyc4++o+nbnh8hl3Cj4QvnFrKib35IWEpvE1g80E3
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094ebd7e-c2db-4346-95e0-08d79506e18b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 13:21:49.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1TLFRo5TtYlPb3vT7dJwDNhRLIP0u+ftO2Q1LeE9EbZ8HmBWAdnEXPT0pwEl6/mpmO0m3HzhX72n2DVFwWRQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4190
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Mon, Jan 6, 2020 at 6:30 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hi Tzvetomir,
>
> I was looking at the plugin options, and I believe it needs to be
> updated.
>
> 1) the tep_plugin_option structure:
>
>   - rename "file" to "plugin"
>   - remove "plugin_alias"
>
> 2) Currently we have the following plugin option functions exported in
> trace-cmd:
>
>  char **tep_plugin_list_options(void);
>  void tep_plugin_free_options_list(char **list);
>  int tep_plugin_add_options(const char *name,
>                            struct tep_plugin_option *options);
>  int tep_plugin_add_option(const char *name, const char *val);
>  void tep_plugin_remove_options(struct tep_plugin_option *options);
>  void tep_plugin_print_options(struct trace_seq *s);
>  void tep_print_plugins(struct trace_seq *s,
>                         const char *prefix, const char *suffix,
>                         const struct tep_plugin_list *list);
>
> What we should only have is:
>
>  int tep_plugin_add_options(const char *plugin,
>                           struct tep_plugin_option *options);
>  int tep_plugin_set_option(const char *plugin, const char *name,
>                           const char *val);
>  int tep_plugin_remove_options(struct tep_plugin_option *options);
>  struct tep_plugin_option const * const tep_plugin_options_list(void);
>
>
> Where:
>
>   tep_plugin_add_options() is basically the same as we have now. But we
>     should change it so that if "plugin" is already registered, it
>     should fail with -EBUSY.
>
>  tep_plugin_set_option() lets us update the option. If "plugin" is
>    NULL, then it will ignore that value, and will set all options with
>    "name" to "val", regardless of what plugin it belongs to.
>
>  tep_plugin_remove_options() is basically the same as what we have now,
>    and removes the options from the list.
>
>  tep_plugin_options_list() returns an immutable list of all the
>    registered plugin options. This is the list that the application can
>    use to see what options are registered, as well as their default
>    (and current) values.
>
> Does this make sense?

Yes, it makes sense. I'll submit a patch set with these changes, in
the kernel tree.
I'm going to add also a check at the plugin loading time, if it is
already loaded -
the old one will be unloaded before the new one is registered.

>
> -- Steve

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
